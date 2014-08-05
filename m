Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbaHEJrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:47:49 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:54761 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563AbaHEJrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:47:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140805103409.33afef2a@alan.etchedpixels.co.uk>
References: <CAPybu_1Ma+7nGaS0e17HpPcM1vk6ANSFN3C8MNR=JxWrBBmMOA@mail.gmail.com>
 <1406834546-23033-1-git-send-email-ricardo.ribalda@gmail.com>
 <20140801132343.45153300@alan.etchedpixels.co.uk> <CAPybu_2U2jjyY_9gji41mUc5F4N+idDVNO=LAr3F5PpJ0JzYSg@mail.gmail.com>
 <20140805103409.33afef2a@alan.etchedpixels.co.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 5 Aug 2014 11:47:26 +0200
Message-ID: <CAPybu_0CcmF0+Z8kE9A=uD7PvWeaC_ro8pF1NVNjuTMVcPgkMw@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] serial: Add support for Fintek F81216A LPC to 4 UART
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Michael Welling <mwelling@ieee.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Joe Schultz <jschultz@xes-inc.com>, Ingo Molnar <mingo@elte.hu>,
        Doug Anderson <dianders@chromium.org>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan

> We really want to handle it at the tty layer I think not at serial_core.
> I have a patch for that and I'm playing with it but it's taking longer
> than I hoped.
>
> In the mean time I think your patch #1 is ok except for the trivial
> item that I'd prefer the struct serial_rs485 was further down the struct
> uart_8250_port. It's packed so that the bits you need most are in the
> first cache line or two.

I have just resend 1/2 with rs485 moved further down on the structure.
Shall I also resend 2/2 (no changes)?

Regards!



-- 
Ricardo Ribalda
