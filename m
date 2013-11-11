Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab3KKTPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:15:16 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41583 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab3KKTPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:15:13 -0500
Date: Mon, 11 Nov 2013 14:05:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-11-11
Message-ID: <20131111190548.GA8107@tuxdriver.com>
References: <20131111182738.GB5648@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111182738.GB5648@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 04:27:38PM -0200, Gustavo Padovan wrote:
> Hi John,
> 
> A few fixes for 3.13. There is 3 fixes to the RFCOMM protocol. One crash fix to
> L2CAP. A simple fix to a bad behaviour in the SMP protocol, and last, an
> revert, that I sent in the last pull request but doesn't seem to be in your
> tree.

Are you looking in the wireless-next tree?  It seems to be there, no?

John

> 
> Please pull or let me know of any issues. Thanks!
> 
> 
> 	Gustavo
> 
> ---
> The following changes since commit 8ce9beac4661f576ea0d518b9f086bb52a171a37:
> 
>   drivers: net: wireless: b43: Fix possible NULL ptr dereference (2013-10-18 13:41:11 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master
> 
> for you to fetch changes up to 3244d4a55c95708b0fa6fd820a9009534ed08a5f:
> 
>   Bluetooth: Fix rejecting SMP security request in slave role (2013-11-11 15:48:36 -0200)
> 
> ----------------------------------------------------------------
> Hans de Goede (1):
>       Bluetooth: revert: "Bluetooth: Add missing reset_resume dev_pm_ops"
> 
> Johan Hedberg (1):
>       Bluetooth: Fix rejecting SMP security request in slave role
> 
> Marcel Holtmann (1):
>       Bluetooth: Fix issue with RFCOMM getsockopt operation
> 
> Seung-Woo Kim (3):
>       Bluetooth: Fix RFCOMM bind fail for L2CAP sock
>       Bluetooth: Fix to set proper bdaddr_type for RFCOMM connect
>       Bluetooth: Fix crash in l2cap_chan_send after l2cap_chan_del
> 
>  drivers/bluetooth/btusb.c   | 1 -
>  net/bluetooth/l2cap_core.c  | 3 +++
>  net/bluetooth/rfcomm/core.c | 3 +++
>  net/bluetooth/rfcomm/sock.c | 6 +++++-
>  net/bluetooth/smp.c         | 3 +++
>  5 files changed, 14 insertions(+), 2 deletions(-)
> 



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
