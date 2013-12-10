Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab3LJBgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:36:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44899 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3LJBgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:36:43 -0500
Date: Mon, 09 Dec 2013 20:36:41 -0500 (EST)
Message-Id: <20131209.203641.194782152490333573.davem@davemloft.net>
To: zwu.kernel@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] macvtap: remove useless codes in
 macvtap_aio_read() and macvtap_recvmsg()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386363300-19040-1-git-send-email-zwu.kernel@gmail.com>
References: <1386363300-19040-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 09 Dec 2013 17:36:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <zwu.kernel@gmail.com>
Date: Sat,  7 Dec 2013 04:54:59 +0800

> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> By checking related codes, it is impossible that ret > len or total_len,
> so we should remove some useless coeds in both above functions.
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Applied.
