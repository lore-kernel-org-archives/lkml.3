Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaDYBpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:45:21 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33966 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaDYBpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:45:17 -0400
Date: Thu, 24 Apr 2014 21:44:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2014-04-24
Message-ID: <20140425014446.GC3410@tuxdriver.com>
References: <20140424145329.GD7832@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424145329.GD7832@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tag has a lot of stuff in it not in the wireless tree.
Please only send me pull requests that only include patches related
to Bluetooth.

John

On Thu, Apr 24, 2014 at 11:53:29AM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> Some fixes for 3.15. There is a revert for the intel driver, a new device id,
> and two important SSP fixes from Johan.
> Also we've noticed that your wireless.git tree is not up to date, so this pull
> was rebased on top of net.git. If you pull from this you'll will be pulling
> net/master from yesterday as well.
> 
> Please pull or let me know of any concerns you have. Thanks!
> 
> 	Gustavo
> 
> ---
> The following changes since commit 6a51b5e4d59e00051e65e836520912cd7c717be1:
> 
>   hisax/icc: add missing semicolon after label (2014-04-22 21:22:47 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for-upstream
> 
> for you to fetch changes up to b66a81831359495b3768ace72452209cdf5d6614:
> 
>   Bluetooth: Add support for Lite-on [04ca:3007] (2014-04-24 12:43:33 +0300)
> 
> ----------------------------------------------------------------
> Johan Hedberg (2):
>       Bluetooth: Fix triggering BR/EDR L2CAP Connect too early
>       Bluetooth: Fix redundant encryption request for reauthentication
> 
> Marcel Holtmann (1):
>       Revert "Bluetooth: Enable autosuspend for Intel Bluetooth device"
> 
> Mohammed Habibulla (1):
>       Bluetooth: Add support for Lite-on [04ca:3007]
> 
>  drivers/bluetooth/ath3k.c | 2 ++
>  drivers/bluetooth/btusb.c | 5 ++---
>  net/bluetooth/hci_conn.c  | 9 ++++++---
>  net/bluetooth/hci_event.c | 6 ++++++
>  4 files changed, 16 insertions(+), 6 deletions(-)
> 



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
