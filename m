Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3BYUqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:46:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56018 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab3BYUqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:46:54 -0500
Date: Mon, 25 Feb 2013 15:46:52 -0500 (EST)
Message-Id: <20130225.154652.1215363481985361759.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-02-25
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130225201748.GC6455@tuxdriver.com>
References: <20130225201748.GC6455@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 25 Feb 2013 12:46:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 25 Feb 2013 15:17:49 -0500

> This is a batch of fixes intended for the 3.9 stream...
> 
> Avinash Patil gives us a mwifiex fix to prevent a system freeze when
> that driver is unloaded.
> 
> Daniel Drake brings a patch to avoid dropping the carrier flag across a
> suspend.  This prevents improper packet drops.
> 
> Wei Yongjun delivers a brcmfmac for a lock leak on an error path.
> 
> Please let me know if there are problems!

Pulled, thanks John.
