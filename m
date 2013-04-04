Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794Ab3DDM3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:29:34 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13973 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759543Ab3DDM3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:29:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 04 Apr 2013 05:29:31 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 4 Apr 2013 17:59:24 +0530
Subject: RE: [PATCH v2 6/7] usb: phy: tegra: Add error handling & clean up.
Thread-Topic: [PATCH v2 6/7] usb: phy: tegra: Add error handling & clean up.
Thread-Index: Ac4wonH2EpyMF+W0TN6SuHINPLUHggAjRdcQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6E50BE489E@BGMAIL02.nvidia.com>
References: <1364978502-22887-1-git-send-email-vbyravarasu@nvidia.com>
 <1364978502-22887-7-git-send-email-vbyravarasu@nvidia.com>
 <515C8484.507@wwwdotorg.org>
In-Reply-To: <515C8484.507@wwwdotorg.org>
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
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Thursday, April 04, 2013 1:06 AM
> To: Venu Byravarasu
> Cc: gregkh@linuxfoundation.org; balbi@ti.com;
> stern@rowland.harvard.edu; linux-tegra@vger.kernel.org; linux-
> usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2 6/7] usb: phy: tegra: Add error handling & clean up.
> 
> On 04/03/2013 02:41 AM, Venu Byravarasu wrote:
> > Check return values from all GPIO APIs and handle errors accordingly.
> > Remove clk_disable_unprepare which is no more needed.
> 
> checkpatch fails:

As these are checkpatch warnings only, did not pay much attention on that.
Any how will fix it in next update.

> 
> > WARNING: line over 80 characters
> > #27: FILE: drivers/usb/phy/phy-tegra-usb.c:547:
> > +		dev_err(phy->dev, "gpio %d direction not set\n", phy-
> >reset_gpio);
> >
> > WARNING: line over 80 characters
> > #34: FILE: drivers/usb/phy/phy-tegra-usb.c:553:
> > +		dev_err(phy->dev, "gpio %d direction not set\n", phy-
> >reset_gpio);
> >
> > total: 0 errors, 2 warnings, 72 lines checked
> >
> > 0006-usb-phy-tegra-Add-error-handling-clean-up.patch has style problems,
> please review.

