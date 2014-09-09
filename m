Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbaIIPll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:41:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:54323 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaIIPlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:41:39 -0400
Date: Tue, 9 Sep 2014 17:41:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
        Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: AW: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
In-Reply-To: <540F1C43.2080708@zytor.com>
Message-ID: <alpine.DEB.2.10.1409091740220.11037@nanos>
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5683.6030708@zytor.com> <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5BB6.9070405@zytor.com> <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.e
 <0363648bf9644167bf5aa0a954cd145b@DB4PR04MB265.eurprd04.prod.outlook.com> <540F06F1.1040608@lsexperts.de> <alpine.DEB.2.10.1409091649510.11037@nanos> <540F1C43.2080708@zytor.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014, H. Peter Anvin wrote:

> On 09/09/2014 07:54 AM, Thomas Gleixner wrote:
> > 
> > @hpa: You asked whether this might affect any other e6xx devices.
> > 
> > According to the atom e6xx-series datasheet the HPET is non optional
> > and always memory mapped to 0xfed00000. I don't see how that would
> > harm any machine which has the hpet proper advertised via ACPI.
> > 
> 
> That seems straightforward then.
> 
> I still wish someone would take a cluebat to Soekris.  We keep hearing
> crap like this about their firmware over and over and over again.  It
> isn't like you can't get EDK2 or Coreboot and build a BIOS based mostly
> on Open Source components these days... oh, wait.

You can, but I have a non soekris e6xx platform with a BLDK based BIOS
which lacks ACPI and some other features....

