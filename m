Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaKNJQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:16:38 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:54897 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaKNJQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:16:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Simon Horman <horms@verge.net.au>, Joe Perches <joe@perches.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus <magnus.damm@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3] of: replace Asahi Kasei Corp venter prefix
Date: Fri, 14 Nov 2014 10:16:18 +0100
Message-ID: <2984171.bo9yu8oQT6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5465BFA2.9050706@nvidia.com>
References: <5398AB07.4040304@wwwdotorg.org> <87k32yd0bd.wl%kuninori.morimoto.gx@renesas.com> <5465BFA2.9050706@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:THN4BUS9LU9Igd+RRA2AM1ENJG80VJRmA3tU2j1TX+5
 UnL7asAOuqih8PBf8eRNKSQJPcJrkHTw0ce/HnEDM/5Eo+jbu+
 ipegUc2WZhgM2THy18IxOZ1j3nJcKH/S3KZufJYaejsW4zUkTQ
 A5Xw9LecigG/ajWtVP0NiasuTKbN3NYFvLOyn/Cy2Pgk8OC9YO
 CUzSCRroUmjekf3pWPF0tB/JgQN2LrgFyvZQ6e1l+DfnYmI9v/
 hG7Bympf2RHwalyJEumtjuJJh/CIfa+V4KAhxHUuB9qen0mnCT
 xfT+4pPzyJ9Z3bEgsIV4dbdNtI7qXMiOdBWQ8P/a1gpe+RhyXf
 K27soNfz/JafJmMzZ2u4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2014 17:38:58 Alexandre Courbot wrote:
> > diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
> > index a1d4bf9..7f5cf80 100644
> > --- a/arch/arm/boot/dts/tegra20-seaboard.dts
> > +++ b/arch/arm/boot/dts/tegra20-seaboard.dts
> > @@ -405,7 +405,7 @@
> >               clock-frequency = <400000>;
> >
> >               magnetometer@c {
> > -                     compatible = "ak,ak8975";
> > +                     compatible = "asahi-kasei,ak8975";
> 
> Mmm. So does this mean this device was never probed because the driver 
> did not recognize its compatible property? I cannot find "ak,ak8975" 
> anywhere else in the kernel.
> 

No, the i2c bus behaves in a special way by matching the "ak8975"
i2c driver name with any "*,ak8975" DT compatible string. Both
of the above will work with existing kernels.

	Arnd
