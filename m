Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaK1MHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:07:37 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:64775 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaK1MHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:07:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alexander Stein <alexanders83@web.de>,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 00/11] ARM: at91: remove !DT support for at91rm9200
Date: Fri, 28 Nov 2014 13:06:40 +0100
Message-ID: <25050514.vKmbVUQfkQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141128113111.GO4508@piout.net>
References: <cover.1417103399.git.nicolas.ferre@atmel.com> <2770184.6f6RpLLlMS@wuerfel> <20141128113111.GO4508@piout.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:p5g4HG5yKFoPJTfyRHKvwgKsjAIeyjNW6XGdcWHuhHU
 qtUji7kH/Uy+iJmPDb27nxku3FMjqG0dvgWKeh7g+yOY/Kwbpy
 i0FCGQQCrdjAgWvbU+aZyNAlL3SHW9IcJamDeZikPkaOXEaRMa
 HSdBMCVQZ+55gBjcJI37Tnt8l/g5ZEd/h0EayvOlJndSVzPj0O
 d9/K/beKRYdeUdtc5MmX40CBQ12twXcuVCacW+FXPJQo697OOZ
 xa/ihm3wzpiwMuoLLFV3sOj2gmAhD7HCG/4HTOgtNSHMNdR0qu
 HZQl4/VZrzrJJZAIx/As7G4Evh2QNU1iq6YRa51yVq7OqEhzJO
 mFRQX7WQLGlMz014SEu0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 November 2014 12:31:12 Alexandre Belloni wrote:
> On 28/11/2014 at 09:49:10 +0100, Arnd Bergmann wrote :
> > > > Actually, some work was done but we never saw an other version of the
> > > > series. Alexander, are you still interested? Else we can take the patch
> > > > below.
> > > > 
> > > > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/246679.html
> > 
> > I see. Yes, the approach is similar, and there are actually multiple
> > independent problems:
> > 
> > - getting the current driver to build with multiplatform (trivial, 5 lines)
> > - changing the gpio handling to work with DT (simple, both of us did that)
> > - writing the binding (simple)
> 
> Yeah, let's focus on those first steps. Takashi was willing to take
> patches, even if we were not converting the driver to ASoC.
> 
> > - changing the driver to ASoC (not that simple)
> > 
> > > Well, I tried to get a ac97c driver based on alsa soc framework as suggested 
> > > by Takashi. But I failed so far, I could not get my head around those 
> > > architecture.
> > 
> > Let's just start with the trivial first patch, that can probably just be merged
> > into 3.19, and then we can build on top of that later if anybody wants to
> > get ac97 working again on at91.
> > 
> 
> Do you want one of us to send that patch to Takashi and the Alsa ML or
> will you do it?
> You can add my ack.

Please send it after you have checked that it actually works, I only
took a snippet from my earlier patch assuming it would be sufficient,
but I didn't try.

	Arnd
