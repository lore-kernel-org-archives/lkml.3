Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513Ab3B0JH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 04:07:26 -0500
Received: from canardo.mork.no ([148.122.252.1]:45776 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756920Ab3B0JHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 04:07:23 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: gdt@gdt.id.au
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/net/asix_devices: Add USBNET HG20F9 ethernet dongle
Organization: m
References: <1361852232.23197.4.camel@andromache.adelaide.aarnet.edu.au>
	<20130226.172856.235525833921140241.davem@davemloft.net>
	<20130226.172955.926853809838377302.davem@davemloft.net>
Date: Wed, 27 Feb 2013 10:07:11 +0100
In-Reply-To: <20130226.172955.926853809838377302.davem@davemloft.net> (David
	Miller's message of "Tue, 26 Feb 2013 17:29:55 -0500 (EST)")
Message-ID: <87zjyq86rk.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

>> Applied, thanks Glen.
>
> Actually, I had to revert, this doesn't even compile against
> current sources:
>
>   CC [M]  drivers/net/usb/asix_devices.o
> drivers/net/usb/asix_devices.c:941:14: error: ‘asix_rx_fixup’ undeclared here (not in a function)
> make[1]: *** [drivers/net/usb/asix_devices.o] Error 1
> make: *** [drivers/net/usb/asix_devices.o] Error 2

I believe this patch will make checkpatch cry

  ERROR: do not use C99 // comments

as well.  It would be nice if that was fixed as well before resending.
But please keep the commit message :)


Bjørn
