Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab3LFRxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:53:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40752 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316Ab3LFRxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:53:38 -0500
Date: Fri, 06 Dec 2013 12:53:33 -0500 (EST)
Message-Id: <20131206.125333.99786964245578540.davem@davemloft.net>
To: zwu.kernel@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [net-next PATCH v3 4/6] macvtap: adjust
 macvtap_skb_to_vnet_hdr() to be void
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386310782-9378-5-git-send-email-zwu.kernel@gmail.com>
References: <1386310782-9378-1-git-send-email-zwu.kernel@gmail.com>
	<1386310782-9378-5-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Dec 2013 09:53:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <zwu.kernel@gmail.com>
Date: Fri,  6 Dec 2013 14:19:40 +0800

> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

As mentioned elsewhere, please combine the change that removes the return
value check with the change which adjusts the function return type to "void".

Thank you.
