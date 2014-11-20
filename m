Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbaKTPXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:23:33 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:64954 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaKTPXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:23:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>, Joel Schopp <Joel.Schopp@amd.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Liviu Dudau <liviu.dudau@arm.com>
Subject: Re: [PATCH V3] arm64: amd-seattle: Adding device tree for AMD Seattle platform
Date: Thu, 20 Nov 2014 16:23:16 +0100
Message-ID: <4486649.FEg9dS3gj1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_Jsq+J3izFDepJ04Lb=caUOKJ4eNja0NrhqowyCOEPBVAPdA@mail.gmail.com>
References: <1414503414-3863-1-git-send-email-suravee.suthikulpanit@amd.com> <8642876.4lpJWZTuhf@wuerfel> <CAL_Jsq+J3izFDepJ04Lb=caUOKJ4eNja0NrhqowyCOEPBVAPdA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3Yp/nMEg7xTDoYToP0+si3OwfIT27sb+BF5JEjQSFGS
 OgCv+i3x+lFyPvZSfUIOWfyNlsH7sLW25vxGUNjfPiH1ipdUvB
 0MUCLohGKpaj0xMqhNbZCQ8C4NirEh9JdH84tUGAvZ1RkQyQ3C
 rhVBh4/TJg1Brf3sx3zUpQD5yXv+ZGSZ6lFHjUDlY9a51wV7ub
 TIpNTPebuStRExxgI7gQDjsyXF3iRJVvQx+F8ApnjTG3357MPc
 HQtftkoHuoOSEogClKRobpYlRZamYmBeUWA1bsz88DSDgRF7rF
 pmfHZ/cOeZVDbwSPeUdHUhOYZyD8/UQL5RGS33tCxAFVM2Gl2d
 Fdh3j1MSzLfgkIVn/W9M=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2014 09:16:31 Rob Herring wrote:
> 
> >> +             dma-coherent;
> >> +     };
> >
> > Same here: you list it as coherent, but not 64-bit DMA capable.
> > Is that intentional?
> 
> AHCI controllers are probeable as to whether they support 64-bit DMA or not.
> 

The controller is, but the bus is not, so we also need the dma-ranges
property in the bus.

	Arnd
