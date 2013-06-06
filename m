Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab3FFUXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:23:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51367 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3FFUXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:23:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re: Uploading linux (3.9.4-1))
Date: Thu, 6 Jun 2013 22:22:53 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Olof Johansson <olof@lixom.net>,
        "devicetree-discuss" <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "luke.leighton" <luke.leighton@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "debian-arm" <debian-arm@lists.debian.org>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        "debian-kernel" <debian-kernel@lists.debian.org>
References: <51AFA6DD.3000202@wwwdotorg.org> <CAOesGMgqxhG45NyCfpHc_0uHS+_Gn-hGZm-+CRvK2EEf1AGTow@mail.gmail.com> <20130606172810.GE14209@lukather>
In-Reply-To: <20130606172810.GE14209@lukather>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306062222.53780.arnd@arndb.de>
X-Provags-ID: V02:K0:IvCsWYXAgm+8zNjq3Scb4aBn2dEGEOaSjiOKSJsjC4i
 FcZ6hewa3IwmcI1fDJSxqmbDPd3zyBHnHlPuaHpR8/5n/zrnJh
 pWK5/Tob811Tqs09DXuiTYzM3HHOep/RAqugTiaV+EUAcuhbB1
 GillpDk2C9XXThtBI5ihVgGsKwGNHmr44MNa0Lp1aMmhU79QD9
 XNhlWQrJil0osMj1epsWokHZHX4Qhpjq+dgwSSPjpqAViwcX1N
 CsM70MeedLDDmLzCI02BYGy9kYakmX4f3dOPQ3tVqRf1PVuUKo
 LNLXoC1i27zrO2/NfyxRtH3E6R2FRbuLnkl94eE+si8EbldZFg
 tnfD1feJJffpkKb0pexI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 June 2013, Maxime Ripard wrote:
> So yes, Allwinner has an evil vendor tree (c), with a solution similar yet
> inferior (because not generic enough) to the device tree, but they show
> interest on going down the mainline road.

Right, and of course there is nothing special about that, everybody starts
out with they own even vendor tree (c), and as hardware support gets merged
upstream, the diff gets smaller, even though the code in the mainline
kernel is normally very different from what they started out with.

Chances are actually that the Allwinner (A10/A13/A20, not A31) platform may
end up being the first modern one that is fully supported upstream including
a GPU driver, since it is one of the obvious targets for the
reverse-engineering efforts. Ironically (given NVIDIA's reputation), the
Tegra platform is the strongest competitor I see in that race at the moment.

For all I can tell, things are progressing nicely, given that it's currently
a volunteer effort. If anyone needs things to move faster, I'd recommend
them to send money to free-electrons.com.

	Arnd
