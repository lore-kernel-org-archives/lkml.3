Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199Ab3EGQlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:41:00 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:43447 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758941Ab3EGQk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:40:59 -0400
X-Auth-Info: 2IOpTnQHcf2QKkM9wToEjxgCrGhZ9M3a9dmS0ZrdMWA=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org
Subject: Re: Build errors caused by modalias generation patch
References: <20130506160253.GA27181@linux-mips.org>
X-Yow: I'm EXCITED!!  I want a FLANK STEAK WEEK-END!!  I think I'm JULIA
 CHILD!!
Date: Tue, 07 May 2013 18:40:54 +0200
In-Reply-To: <20130506160253.GA27181@linux-mips.org> (Ralf Baechle's message
	of "Mon, 6 May 2013 18:02:54 +0200")
Message-ID: <874neeu4ix.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle <ralf@linux-mips.org> writes:

> cobalt_defconfig:
>
>   CC [M]  drivers/hid/usbhid/hid-quirks.o
>   LD [M]  drivers/hid/usbhid/usbhid.o
> FATAL: drivers/hid/usbhid/usbhid: sizeof(struct usb_device_id)=32 is not a modulo of the size of section __mod_usb_device_table=48.
> Fix definition of struct usb_device_id in mod_devicetable.h

What are the contents of devicetable-offsets.[sh]?

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
