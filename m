Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab3CTMRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:17:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9490 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3CTMRx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:17:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Mar 2013 05:10:37 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: kishon <kishon@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Wed, 20 Mar 2013 17:47:46 +0530
Subject: RE: [PATCH 2/7] ARM: tegra: update device trees for USB binding
 rework
Thread-Topic: [PATCH 2/7] ARM: tegra: update device trees for USB binding
 rework
Thread-Index: Ac4lXVsDPDyifDc7RHeLSH2bIC0U8AAB1Ahw
Message-ID: <D958900912E20642BCBC71664EFECE3E6E5092FFE7@BGMAIL02.nvidia.com>
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com>
 <1363609781-4045-3-git-send-email-vbyravarasu@nvidia.com>
 <51499C29.6070405@ti.com>
In-Reply-To: <51499C29.6070405@ti.com>
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
> From: kishon [mailto:kishon@ti.com]
> Sent: Wednesday, March 20, 2013 4:53 PM
> To: Venu Byravarasu
> Cc: gregkh@linuxfoundation.org; stern@rowland.harvard.edu;
> balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> swarren@wwwdotorg.org; linux-tegra@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org
> Subject: Re: [PATCH 2/7] ARM: tegra: update device trees for USB binding
> rework
> 
> Hi,
> 
> On Monday 18 March 2013 05:59 PM, Venu Byravarasu wrote:
> > This patch updates all Tegra board files so that they contain all the
> > properties required by the updated USB DT binding. Note that this patch
> > only adds the new properties and does not yet remove the old properties,
> > in order to maintain bisectability. The old properties will be removed
> > once the driver has been updated to assume the new bindings.
> >
> > Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> > ---
> >   arch/arm/boot/dts/tegra20-colibri-512.dtsi |    4 +++
> >   arch/arm/boot/dts/tegra20-harmony.dts      |    8 +++---
> >   arch/arm/boot/dts/tegra20-iris-512.dts     |    4 +++
> >   arch/arm/boot/dts/tegra20-paz00.dts        |    8 +++---
> >   arch/arm/boot/dts/tegra20-seaboard.dts     |   13 +++++++---
> >   arch/arm/boot/dts/tegra20-trimslice.dts    |   12 +++++++---
> >   arch/arm/boot/dts/tegra20-ventana.dts      |    7 +++--
> >   arch/arm/boot/dts/tegra20.dtsi             |   32 +++++++++++++++++----------
> >   8 files changed, 57 insertions(+), 31 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
> b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
> > index cb73e62..af5a7ae 100644
> > --- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
> > +++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
> > @@ -443,6 +443,10 @@
> >   		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
> >   	};
> >
> > +	usb-phy@c5004000 {
> This node doesn't have a *reg* property. So "@c5004000" is not needed.
> This comment applies to all the nodes which doesn't have *reg* property.

Thanks Kishon for the comments.
As I've 3 usb-phy DT nodes, how to differentiate between them if I remove this @Address ?

> 
> Thanks
> Kishon
