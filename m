Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3KKXRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:17:34 -0500
Received: from senator.holtmann.net ([87.106.208.187]:44786 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3KKXRZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:17:25 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: pull request: bluetooth 2013-11-11
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20131111182738.GB5648@joana>
Date: Tue, 12 Nov 2013 08:17:15 +0900
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org Wireless" 
	<linux-wireless@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D2BE5A4D-1193-4E8A-AA03-47221248C736@holtmann.org>
References: <20131111182738.GB5648@joana>
To: "Gustavo F. Padovan" <gustavo@padovan.org>
X-Mailer: Apple Mail (2.1822)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

> A few fixes for 3.13. There is 3 fixes to the RFCOMM protocol. One crash fix to
> L2CAP. A simple fix to a bad behaviour in the SMP protocol, and last, an
> revert, that I sent in the last pull request but doesn't seem to be in your
> tree.
> 
> Please pull or let me know of any issues. Thanks!
> 
> 
> 	Gustavo
> 
> ---
> The following changes since commit 8ce9beac4661f576ea0d518b9f086bb52a171a37:
> 
>  drivers: net: wireless: b43: Fix possible NULL ptr dereference (2013-10-18 13:41:11 -0400)
> 
> are available in the git repository at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master
> 
> for you to fetch changes up to 3244d4a55c95708b0fa6fd820a9009534ed08a5f:
> 
>  Bluetooth: Fix rejecting SMP security request in slave role (2013-11-11 15:48:36 -0200)
> 
> ----------------------------------------------------------------
> Hans de Goede (1):
>      Bluetooth: revert: "Bluetooth: Add missing reset_resume dev_pm_ops”

this one is already in net-next actually. John pushed bluetooth and bluetooth-next to Dave at the same time.

> Johan Hedberg (1):
>      Bluetooth: Fix rejecting SMP security request in slave role
> 
> Marcel Holtmann (1):
>      Bluetooth: Fix issue with RFCOMM getsockopt operation
> 
> Seung-Woo Kim (3):
>      Bluetooth: Fix RFCOMM bind fail for L2CAP sock
>      Bluetooth: Fix to set proper bdaddr_type for RFCOMM connect
>      Bluetooth: Fix crash in l2cap_chan_send after l2cap_chan_del

These 5 fixes are still needed.

Regards

Marcel

