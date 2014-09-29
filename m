Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaI2DRu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 23:17:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49946 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaI2DRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 23:17:48 -0400
Date: Sun, 28 Sep 2014 23:16:47 -0400 (EDT)
Message-Id: <20140928.231647.1355757349883305047.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers: net-next: hyperv: Fix a bug in
 netvsc_start_xmit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411958991-28049-1-git-send-email-kys@microsoft.com>
References: <1411958991-28049-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Sep 2014 20:17:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Sun, 28 Sep 2014 19:49:51 -0700

> After the packet is successfully sent, we should not touch the skb as it may
> have been freed. This patch is based on the work done by
> Long Li <longli@microsoft.com>. 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Tested-by: Long Li <longli@microsoft.com>
> Cc: <stable@vger.kernel.org>

You hyperv guys really have to get your act together.  This is not
properly submitted.

Most importantly, this is a serious reference to free memory bug.
Therefore it should be targetted at 'net' not 'net-next'.

Secondly, you do not CC: stable for networking changes, you instead
ask me to queue it up for my next batch of -stable networking changes.

Thirdly, your Subject line is malformed.  You should not use
"Drivers: " as a prefix.  Just the driver name is sufficient.
You should also not mentionen the target GIT tree outside of the
[PATCH ...] bracketed area.

Also, please be cognizant of how much of my time you unnecessarily
consume when you make a malformed submission like this.  That is
time I could spend reviewing other patches.

Thank you.
