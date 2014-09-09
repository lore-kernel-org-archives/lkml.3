Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaIITaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:30:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51800 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaIITaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:30:11 -0400
Date: Tue, 9 Sep 2014 15:16:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-09-09
Message-ID: <20140909191612.GM29412@tuxdriver.com>
References: <20140909155449.GA7412@t440s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909155449.GA7412@t440s>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 08:54:49AM -0700, Johan Hedberg wrote:
> Hi John,
> 
> This set of patches is intended for 3.18. Most of the patches are LE SMP
> (Security Manager Protocol) fixes/improvements, but there are also some
> 6lowpan fixes as well as a fix for the btusb HCI driver.
> 
> Please let me know if there are any issues pulling. Thanks.
> 
> Johan
> 
> ---
> The following changes since commit 61a3d4f9d52c00b2016bc27fc66b10a194043f76:
> 
>   Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless (2014-09-08 11:14:56 -0400)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to 39e90c77637b3892a39f2908aea57539e961c50e:
> 
>   Bluetooth: 6lowpan: Route packets that are not meant to peer via correct device (2014-09-09 15:51:47 +0200)
> 
> ----------------------------------------------------------------
> Behan Webster (1):
>       Bluetooth: LLVMLinux: Remove VLAIS from bluetooth/amp.c
> 
> Champion Chen (1):
>       Bluetooth: Fix issue with USB suspend in btusb driver
> 
> Johan Hedberg (31):
>       Bluetooth: Fix incorrect LE CoC PDU length restriction based on HCI MTU
>       Bluetooth: Remove unnecessary l2cap_chan_unlock before l2cap_chan_add
>       Bluetooth: Fix hci_conn reference counting for fixed channels
>       Bluetooth: Set addr_type only when it's needed
>       Bluetooth: Optimize connection parameter lookup for LE connections
>       Bluetooth: Improve *_get() functions to return the object type
>       Bluetooth: Fix using hci_conn_get() for hci_conn pointers
>       Bluetooth: Refactor connection parameter freeing into its own function
>       Bluetooth: Use zero timeout for immediate scheduling
>       Bluetooth: Fix hci_conn reference counting with hci_chan
>       Bluetooth: Set disc_timeout to 0 when calling hci_chan_del
>       Bluetooth: Ignore incoming data after initiating disconnection
>       Bluetooth: Remove hci_conn_hold/drop from hci_chan
>       Bluetooth: Set discon_timeout to 0 in l2cap_conn_del
>       Bluetooth: Use hci_disconnect for immediate disconnection from SMP
>       Bluetooth: Remove unused l2cap_conn_shutdown API
>       Bluetooth: Fix SMP error and response to be mutually exclusive
>       Bluetooth: Update hci_disconnect() to return an error value
>       Bluetooth: Use hci_disconnect() for mgmt_disconnect_device()
>       Bluetooth: Move clock offset reading into hci_disconnect()
>       Bluetooth: Add clarifying comment for LE CoC result value
>       Bluetooth: Remove unnecessary checks after canceling SMP security timer
>       Bluetooth: Don't take any action in smp_resume_cb if not encrypted
>       Bluetooth: Move identity address update behind a workqueue
>       Bluetooth: Remove unnecessary deferred work for SMP key distribution
>       Bluetooth: Fix locking of the SMP context
>       Bluetooth: Add define for key distribution mask
>       Bluetooth: Fix calling smp_distribute_keys() when still waiting for keys
>       Bluetooth: Add strict checks for allowed SMP PDUs
>       Bluetooth: Fix dereferencing conn variable before NULL check
>       Bluetooth: Fix mgmt pairing failure when authentication fails
> 
> Jukka Rissanen (3):
>       Bluetooth: 6lowpan: Increase the connection timeout value
>       Bluetooth: 6lowpan: Set the peer IPv6 address correctly
>       Bluetooth: 6lowpan: Route packets that are not meant to peer via correct device

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
