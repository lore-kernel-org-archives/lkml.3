Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3AVX4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:56:15 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5949 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3AVX4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:56:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 22 Jan 2013 15:54:43 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Roger Quadros <rogerq@ti.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jan 2013 05:26:05 +0530
Subject: RE: [PATCH v2] usb: phy: moving all PHY API definitions to usb/phy
 directory
Thread-Topic: [PATCH v2] usb: phy: moving all PHY API definitions to usb/phy
 directory
Thread-Index: Ac34q8TYEcaIEAYiTiO4z4pslnX/swAT2Y+A
Message-ID: <D958900912E20642BCBC71664EFECE3E6E1B13B787@BGMAIL02.nvidia.com>
References: <1358852471-28260-1-git-send-email-vbyravarasu@nvidia.com>
 <50FEA059.7080903@ti.com>
In-Reply-To: <50FEA059.7080903@ti.com>
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
> From: Roger Quadros [mailto:rogerq@ti.com]
> Sent: Tuesday, January 22, 2013 7:51 PM
> To: Venu Byravarasu
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] usb: phy: moving all PHY API definitions to usb/phy
> directory
> 
> On 01/22/2013 01:01 PM, Venu Byravarasu wrote:
> > As drivers/usb/otg/otg.c contains most of the PHY related APIs
> > which are not OTG specific, moving them to more logical place
> > under driver/usb/phy.
> >
> > Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> > ---
> > delta from v1:
> > Missed adding newly created file usb_phy.c with previous patch.
> > hence sending v2, after adding that.
> >
> >  drivers/usb/otg/otg.c                    |  184 ------------------------------
> >  drivers/usb/phy/Makefile                 |    1 +
> >  drivers/usb/{otg/otg.c => phy/usb_phy.c} |   45 +-------
> >  3 files changed, 6 insertions(+), 224 deletions(-)
> >  copy drivers/usb/{otg/otg.c => phy/usb_phy.c} (82%)
> 
> what about updating
> drivers/usb/otg/Makefile and Kconfig?
> 
> i.e. remove CONFIG_USB_OTG_UTILS and otg.o there?

Thanks for your comments.
Those files may still be needed, as we're not removing otg.c,
due to remaining only otg function i.e. otg_state_string().

Felipe,
Shall I move otg_state_string() to otg.h and remove otg.c altogether?

> 
> --
> cheers,
> -roger
> 
