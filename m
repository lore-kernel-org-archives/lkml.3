Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaGJHnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:43:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36940 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaGJHnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:43:21 -0400
Date: Thu, 10 Jul 2014 00:43:20 -0700 (PDT)
Message-Id: <20140710.004320.637979706845569125.davem@davemloft.net>
To: jy0922.shim@samsung.com
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, steve.glendinning@shawell.net,
        drake@endlessm.com
Subject: Re: [PATCH] usbnet: smsc95xx: add reset_resume function with reset
 operation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404960582-28096-1-git-send-email-jy0922.shim@samsung.com>
References: <1404960582-28096-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 10 Jul 2014 00:43:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonyoung Shim <jy0922.shim@samsung.com>
Date: Thu, 10 Jul 2014 11:49:42 +0900

> The smsc95xx needs to resume with reset operation. Otherwise it causes
> system hang by network error like below after resume. This case appears
> on odroid u3 board.
> 
> [    9.727600] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
> [    9.727648] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
> [    9.727689] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
> [    9.727728] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
> [    9.729486] PM: resume of devices complete after 2011.219 msecs
> [   10.117609] Restarting tasks ... done.
> [   11.725099] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
> [   13.480846] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
> [   13.481361] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
> ...
> 
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>

Applied.
