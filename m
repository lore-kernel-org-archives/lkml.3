Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaKNT6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:58:49 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:62607 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaKNT6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:58:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Feng Kan <fkan@apm.com>, =devicetree@vger.kernel.org,
        patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bao Truong <btruong@apm.com>
Subject: Re: [PATCH V2 1/7] arm64: dts: Add APM X-Gene USB DTS node
Date: Fri, 14 Nov 2014 20:58:43 +0100
Message-ID: <13891778.lvGnz7oB4J@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL85gmCXBFCs6dNQXDLh4HAgZ4SN7Wwnon_D3a4q_Rq3oz-Vvg@mail.gmail.com>
References: <1415924401-3013-1-git-send-email-fkan@apm.com> <2126031.OOHBs2pzVu@wuerfel> <CAL85gmCXBFCs6dNQXDLh4HAgZ4SN7Wwnon_D3a4q_Rq3oz-Vvg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:JPfBpFDqSii3jcAcBvBJovgHNTp5nvECYNr6k5FWddp
 oGkdrOSFvRsqThaIRFA108wC238Ag92CTWU/bKPWGL15hxnXfM
 PDnIMlSwfpORzvYCpL1y4aNH/VDVMFG9u36ffIE2FHbPhy5g/C
 RCSgDxrYn9IkNgFwaHbTww3D1GVbM46vVbaa4P6GGF8CjpaJu6
 SHba2z5xLbDD6vOa6NXz7pIKTMPCyKKVgacv0qm9h7+T9cIXfu
 8vasuhFIIQc7gGxTuBzJ4NHTCVDXbFvtxsxDf3I0zq6Foh1pUj
 iJDm0hLN58cZKJ7o/WRNz37aa4PBSglM6kdDdO3cfQuLYkGhU6
 07ZZwJ1HFIQ0QKTp0KN4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2014 11:17:38 Feng Kan wrote:
> On Fri, Nov 14, 2014 at 7:04 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 13 November 2014 16:19:55 Feng Kan wrote:
> >>
> >> +               usb0: dwusb@19000000 {
> >> +                       status = "disabled";
> >> +                       compatible = "xhci-platform";
> >> +                       reg =  <0x0 0x19000000 0x0 0x100000>;
> >> +                       interrupts = <0x0 0x89 0x4>;
> >> +                       dma-coherent;
> >> +               };
> >> +
> >> +               usb1: dwusb@19800000 {
> >> +                       status = "disabled";
> >> +                       compatible = "xhci-platform";
> >> +                       reg =  <0x0 0x19800000 0x0 0x100000>;
> >> +                       interrupts = <0x0 0x8a 0x4>;
> >> +                       dma-coherent;
> >> +               };
> >>
> >
> > Call the nodes 'usb', not 'dwusb'.
> This was a deliberate change on our part to make sure backward
> compatibility with a older bootloader.

Ok, then add a comment above the nodes explaining this, to prevent
people from cleaning it up and accidentally breaking your boot loader
later.

	Arnd
