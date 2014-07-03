Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaGCBFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 21:05:01 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:32770 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaGCBE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 21:04:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140702065531.GS28884@atomide.com>
References: <CAPDOMVgP83G4-znp=9kB-pBrfd2MUK+xvw1-_cRMXqi9P8hrww@mail.gmail.com>
	<20140702065531.GS28884@atomide.com>
Date: Wed, 2 Jul 2014 21:04:58 -0400
Message-ID: <CAPDOMVi0E9vsfMsXfxM5SivnO8nDXaP+W+y0Nnuv32+WPQ05jg@mail.gmail.com>
Subject: Re: FIX ME in function ocpi_enable in file arch/arm/mach-omap1/opci.c
From: Nick Krause <xerofoify@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Therefore I will send it a patch removing this FIXME.
Cheers Nick

On Wed, Jul 2, 2014 at 2:55 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Nick Krause <xerofoify@gmail.com> [140701 15:51]:
>> Hey Tony and Russel ,
>> There is a FIX ME message in this function of the file stated in my
>> subject line.
>> I was wondering what locking is needed  here due to not having experience with
>> omap subsystem(s).
>
> Looks like the locking for ocpi_enable would be needed if
> it was called from multiple drivers. We are just enabling all
> access, so no locking neeed for the current usage.
>
> Regards,
>
> Tony
