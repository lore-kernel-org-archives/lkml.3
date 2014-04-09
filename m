Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678AbaDIOE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:04:28 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:36524 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933100AbaDIOE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:04:27 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: David Cohen <david.a.cohen@linux.intel.com>, wim@iguana.be,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: intel-mid: add watchdog platform code for Merrifield
Date: Wed, 09 Apr 2014 16:03:14 +0200
Message-ID: <2205089.MXSpGW1NLo@ws-stein>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140409145848.4cabbb2f@alan.etchedpixels.co.uk>
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com> <3412449.yg5NtfcPeg@ws-stein> <20140409145848.4cabbb2f@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 April 2014 14:58:48, One Thousand Gnomes wrote:
> > I'm getting curious: How can I use device-tree on x86(_64)?
> > Reading the dependencies from CONFIG_OF it can only be used on 32bit systems with some special hardware bases.
> > So, how to use otherwise?
> 
> There isn't any fundamental thing tying device tree to a given
> architecture or 32bitness, it's just that sane PC architectures use ACPI
> to enumerate devices, and/or have a discoverable bus architecture.
> 
> Some of the phones don't so this now becoems a point of consideration. In
> fact it's already also used on CE4100 (which is an embedded media SoC
> found in some TV devices and set-top boxes) and on the OLPC (One laptop
> per child). There is no intrinsic reason it couldn't be used in other x86
> special cases.
> 
> If its PC shaped however it probably has ACPI and ACPI and DT are not a
> 1:1 mapping. ACPI has method invocations, and various firmware provided
> interfaces such as the EC, Device tree is better at some other bits.

Yep, like SPI devices on embedded x86 hardware.

> Converting the phones to embedded device tree rather than adding a
> billion little platform files on the other hand seems to me like a
> no-brainer.

I found http://thread.gmane.org/gmane.linux.drivers.devicetree/4475. Why didn't that get into mainline?

Best regards,
Alexander
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
Am Windrad 2
08468 Heinsdorfergrund
Tel.: 03765 38600-1156
Fax: 03765 38600-4100
Email: alexander.stein@systec-electronic.com
Website: www.systec-electronic.com
 
Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Chemnitz, HRB 28082

