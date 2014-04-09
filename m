Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929AbaDIPSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:18:33 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57521 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836AbaDIPS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:18:29 -0400
Date: Wed, 9 Apr 2014 08:18:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        David Cohen <david.a.cohen@linux.intel.com>, wim@iguana.be,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: intel-mid: add watchdog platform code for
 Merrifield
Message-ID: <20140409151822.GA21864@roeck-us.net>
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com>
 <3412449.yg5NtfcPeg@ws-stein>
 <20140409145848.4cabbb2f@alan.etchedpixels.co.uk>
 <2205089.MXSpGW1NLo@ws-stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2205089.MXSpGW1NLo@ws-stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 04:03:14PM +0200, Alexander Stein wrote:
> On Wednesday 09 April 2014 14:58:48, One Thousand Gnomes wrote:
> > > I'm getting curious: How can I use device-tree on x86(_64)?
> > > Reading the dependencies from CONFIG_OF it can only be used on 32bit systems with some special hardware bases.
> > > So, how to use otherwise?
> > 
> > There isn't any fundamental thing tying device tree to a given
> > architecture or 32bitness, it's just that sane PC architectures use ACPI
> > to enumerate devices, and/or have a discoverable bus architecture.
> > 
> > Some of the phones don't so this now becoems a point of consideration. In
> > fact it's already also used on CE4100 (which is an embedded media SoC
> > found in some TV devices and set-top boxes) and on the OLPC (One laptop
> > per child). There is no intrinsic reason it couldn't be used in other x86
> > special cases.
> > 
> > If its PC shaped however it probably has ACPI and ACPI and DT are not a
> > 1:1 mapping. ACPI has method invocations, and various firmware provided
> > interfaces such as the EC, Device tree is better at some other bits.
> 
> Yep, like SPI devices on embedded x86 hardware.
> 
> > Converting the phones to embedded device tree rather than adding a
> > billion little platform files on the other hand seems to me like a
> > no-brainer.
> 
> I found http://thread.gmane.org/gmane.linux.drivers.devicetree/4475. Why didn't that get into mainline?
> 

Isn't that patch set in mainline ?

We are working on a patch set to make DT support on x86 more
widely available. Thierry Reding did some work on it a while ago.
Some of it is upstream, other parts are available in 
	https://github.com/avionic-design/linux/commits/medatom/master

We'll see if and what will be accepted upstream.

Guenter
