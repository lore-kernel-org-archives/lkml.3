Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab3CTMNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:13:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2366 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917Ab3CTMNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:13:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Mar 2013 05:05:48 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Wed, 20 Mar 2013 17:42:56 +0530
Subject: RE: [PATCH 0/7] USB: PHY: Tegra: registering TEGRA USB PHY as
 platform driver
Thread-Topic: [PATCH 0/7] USB: PHY: Tegra: registering TEGRA USB PHY as
 platform driver
Thread-Index: Ac4k20FsSu4SASIBRPmi9O9pJEYdOAAUaA6QAA2//NA=
Message-ID: <D958900912E20642BCBC71664EFECE3E6E5092FFE2@BGMAIL02.nvidia.com>
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com>
 <5148C1DC.1020903@wwwdotorg.org> 
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Venu Byravarasu
> Sent: Wednesday, March 20, 2013 11:30 AM
> To: 'Stephen Warren'
> Cc: gregkh@linuxfoundation.org; stern@rowland.harvard.edu;
> balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-tegra@vger.kernel.org; devicetree-discuss@lists.ozlabs.org
> Subject: RE: [PATCH 0/7] USB: PHY: Tegra: registering TEGRA USB PHY as
> platform driver
> 
> > -----Original Message-----
> > From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> > Sent: Wednesday, March 20, 2013 1:22 AM
> > To: Venu Byravarasu
> > Cc: gregkh@linuxfoundation.org; stern@rowland.harvard.edu;
> > balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-tegra@vger.kernel.org; devicetree-discuss@lists.ozlabs.org
> > Subject: Re: [PATCH 0/7] USB: PHY: Tegra: registering TEGRA USB PHY as
> > platform driver
> >
> > On 03/18/2013 06:29 AM, Venu Byravarasu wrote:
> > > As part of this series, apart from patch containing changes to register
> > TEGRA
> > > USB PHY driver as platform driver, prepared below patches:
> > > 1. Re-arranging & adding new DT properties.
> > > 2. Getting various params from DT properties added.
> > > 3. code clean up.
> >
> > Venu, I'm curious whether these patches were tested at all. I have found
> > at least two significant problems with trivial testing:
> 
> Stephen,
> Initially started testing after applying each and every patch.
> Like that tested till first 5 patches.
> As did not see any issues till then, applied rest 2 patches at once and tested
> with that.
> Though did not see mouse getting vbus on the 1st boot, Vbus was coming
> fine after disconnect and connect.
> Hence did not test thereafter.
> 
> After checking your current mail, tried now and observed that there seems to
> be some real issue with patch#7 only. (As tried now after applying till patch#
> 6 and did not see this issue).
> Will debug further on patch#7 and update with proper fix after addressing
> your other comments.

Debugged further and found that the issue is because of http://marc.info/?l=linux-arm-kernel&m=135890098024987&w=2 
On reverting that patch and applying it on top of patch#7, able to see  enumeration working fine.

Anyhow, will take care of your other comments and merge this change with patch#7 and resend
for review.

> 
> Thanks for the review & heads up,
> venu
> 
