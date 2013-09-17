Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab3IQPzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:55:54 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:65425 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3IQPzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:55:52 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-35-52387b03c01a
From: Tomasz Figa <t.figa@samsung.com>
To: balbi@ti.com
Cc: Julius Werner <jwerner@chromium.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH 1/3 v5] usb: phy-samsung-usb: Simplify PMU register handling
Date: Tue, 17 Sep 2013 17:53:31 +0200
Message-id: <2133285.Y3nsFRsUq0@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <20130917153616.GG15645@radagast>
References: <1375812017-6287-1-git-send-email-jwerner@chromium.org>
 <CAODwPW8KG2ZxOFf936H233g35KVPjDp+f8e3qgkd4Z7NN9RAtQ@mail.gmail.com>
 <20130917153616.GG15645@radagast>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e/4NV3maosgg1ePhCwO3q+3mH/kHKtF
	25WD7BZvejtYLDoOPWay6F1wlc3i8q45bBYzzu9jsli0rJXZYun1i0wWE6avZbE4vOIAk8Wr
	g20sFvM+72SyWLXrD6MDv8eaeWsYPRZ8vsLuMbvhIovH68kTGD12zrrL7tG3ZRWjx/Eb25k8
	Pm+S89g4NzSAM4rLJiU1J7MstUjfLoEr48Gek4wFhzgqbv45w97AeJGti5GTQ0LARKJ96RFW
	CFtM4sK99UBxLg4hgaWMEkvXd7JCOF1MEm/2bQKrYhNQk/jc8AisW0RAQGL9i0vsIEXMAitY
	JT6taWbsYuTgEBYIkPiyJBekhkVAVeLZupksIDavgKbE0o+72UFsfgF1iXfbnjKB2KICrhKf
	Fm4Ei3MK6EnMe7KMHWLxOkaJI6umM0M0C0r8mHwPbBCzgLzEvv1TWSFsLYn1O48zTWAUnIWk
	bBaSsllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECIm6rzsYlx6zOsQowMGoxMN7
	sdwiSIg1say4MvcQowQHs5IIb0s2UIg3JbGyKrUoP76oNCe1+BAjEwenVAOjK6tLpbV+9Z89
	7RM+sLGG9vQEqr98+eLn8bSpmb2bd0zu/ZzJ7N53OF+H76HlbNuukvXfV8wSfxa4boaqaNfD
	I2ovlygY3orusvxZbPBiX+zL+UcPqnpK3T3Otaxk84lPElM4bL99+hEq+OJpxbM9LPvUkrVX
	ZLn+ZTWO1Hsn0J/9ce7MQLZAJZbijERDLeai4kQA5TUZK5gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Tuesday 17 of September 2013 10:36:16 Felipe Balbi wrote:
> Hi,
> 
> On Tue, Aug 27, 2013 at 01:27:48PM -0700, Julius Werner wrote:
> > *Ping!*
> > 
> > Are there still unanswered concerns left with this patch? I hope my
> > prior mails could clear up why I think that the PMU register
> > description in the device tree for a specific PHY is represents the
> > hardware more accurately after my patch, and my analysis of the
> > Exynos4 situation currently not being implemented (and therefore not
> > needing to be addressed by this patch) was correct. Please let me know
> > if you have further objections... and if not, could we agree to have
> > this picked up somewhere?
> 
> I need acks for DTS part...

This patch breaks Exynos 4, so it's a NAK from me.

Anyway, a new, completely redesigned PHY driver supporting most of the PHY 
features (as opposed to only the basic subset currently) developed by Kamil 
Debski should show up soon, so I don't think there is any reason to apply 
any patches to this old driver.

Best regards,
Tomasz

