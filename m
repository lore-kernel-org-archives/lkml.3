Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab3CaXpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 19:45:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49902 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab3CaXpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 19:45:03 -0400
Date: Sun, 31 Mar 2013 19:45:01 -0400 (EDT)
Message-Id: <20130331.194501.2152753313602353257.davem@davemloft.net>
To: josright123@gmail.com
Cc: wfp5p@virginia.edu, matthew@mattleach.net, gregkh@linuxfoundation.org,
        joseph_chang@davicom.com.tw, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] DM9000B: driver initialization upgrade
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364548422-3051-1-git-send-email-josright123@gmail.com>
References: <1364548422-3051-1-git-send-email-josright123@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 31 Mar 2013 16:45:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph CHANG <josright123@gmail.com>
Date: Fri, 29 Mar 2013 17:13:42 +0800

> Fix bug for DM9000 revision B which contain a DSP PHY
> 
> DM9000B use DSP PHY instead previouse DM9000 revisions' analog PHY,
> So need extra change in initialization, For
> explicity PHY Reset and PHY init parameter, and
> first DM9000_NCR reset need NCR_MAC_LBK bit by dm9000_probe().
> 
> Following DM9000_NCR reset cause by dm9000_open() clear the
> NCR_MAC_LBK bit.
> 
> Without this fix, Power-up FIFO pointers error happen around 2%
> rate among Davicom's customers' boards. With this fix, All above
> cases can be solved.
> 
> Signed-off-by: Joseph CHANG <josright123@gmail.com>

Applied.
