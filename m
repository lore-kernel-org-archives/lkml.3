Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab3A2XMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:12:19 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:42035 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3A2XMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:12:17 -0500
MIME-Version: 1.0
In-Reply-To: <20130129160827.GJ2637@n2100.arm.linux.org.uk>
References: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com>
	<1359474865-15408-2-git-send-email-ruslan.bilovol@ti.com>
	<20130129160827.GJ2637@n2100.arm.linux.org.uk>
Date: Wed, 30 Jan 2013 01:12:17 +0200
X-Google-Sender-Auth: i-Utfr4sVYzmf6rqS-KL4_IDqx0
Message-ID: <CAB=otbR+MA3NUhxqRdo=w81gz9sTLAsLV5ELcpp77UxizMiaKw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] ARM: kernel: update cpuinfo to print CPU model name
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 29, 2013 at 6:08 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Jan 29, 2013 at 05:54:24PM +0200, Ruslan Bilovol wrote:
>> CPU implementer : 0x41
>> CPU name        : OMAP4470 ES1.0 HS
>
> Sigh.  No.  Look at what you're doing - look carefully at the above.
>
> "CPU implementer" - 0x41.  That's A.  For ARM Ltd.  ARM Ltd implemented
> this CPU.  Did ARM Ltd really implement OMAP4470 ?  I think TI would be
> very upset if that were to be the case.

Yes, it would be very surprisingly :)

>
> So no, OMAP4470 is _NOT_ a CPU.  It is a SoC.  The CPU inside the SoC is
> a collection of ARM Ltd Cortex A9 _CPUs_.
>
> See?  Please, learn what a CPU is as opposed to a SoC.

Completely agree with you. I will fix this
