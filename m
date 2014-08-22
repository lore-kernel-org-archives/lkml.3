Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaHVVK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:10:26 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:41706 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaHVVKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:10:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAGVrzcZobuL4z0WNX+Sz4p_uwaPL-S5yvEmgRUwZPJi4+qq0tg@mail.gmail.com>
References: <1408651466-8334-1-git-send-email-abrestic@chromium.org>
	<CAGVrzcZobuL4z0WNX+Sz4p_uwaPL-S5yvEmgRUwZPJi4+qq0tg@mail.gmail.com>
Date: Fri, 22 Aug 2014 14:10:23 -0700
X-Google-Sender-Auth: Xts5yKtEyb28XbhiEuJCARUpm1s
Message-ID: <CAL1qeaGb-o0P7x4nZPJ+dGfoSKz+2ANrB0gGrBi19TtPxVTAZQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] MIPS: Move device-tree files to a common location
From: Andrew Bresticker <abrestic@chromium.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        Qais Yousef <qais.yousef@imgtec.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, John Crispin <blogic@openwrt.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jayachandran C <jchandra@broadcom.com>,
        Paul Burton <paul.burton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 1:42 PM, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On Aug 21, 2014 3:05 PM, "Andrew Bresticker" <abrestic@chromium.org> wrote:
> >
> > To be consistent with other architectures and to avoid unnecessary
> > makefile duplication, move all MIPS device-trees to arch/mips/boot/dts
> > and build them with a common makefile.
>
> I recall reading that the ARM organization for DTS files was a bit unfortunate
> and should have been something like:
>
> arch/arm/boot/dts/<vendor>/
>
> Is this something we should do for the MIPS and update the other architectures
> to follow that scheme?

I recall reading that as well and that it would be adopted for ARM64,
but that hasn't seemed to have happened.  Perhaps Olof (CC'ed) will no
more.
