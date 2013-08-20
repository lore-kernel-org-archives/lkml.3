Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab3HTNdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:33:40 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:52617 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab3HTNdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:33:38 -0400
Message-ID: <1377005543.26268.22.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v4 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB drivers
 for DWC3 core
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Tue, 20 Aug 2013 16:32:23 +0300
In-Reply-To: <20130820122907.GU26587@radagast>
References: <1376992565-22292-1-git-send-email-iivanov@mm-sol.com>
	 <1376992565-22292-3-git-send-email-iivanov@mm-sol.com>
	 <20130820122907.GU26587@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2013-08-20 at 07:29 -0500, Felipe Balbi wrote: 
> Hi,
> 
> On Tue, Aug 20, 2013 at 12:56:04PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > These drivers handles control and configuration of the HS
> > and SS USB PHY transceivers. They are part of the driver
> > which manage Synopsys DesignWare USB3 controller stack
> > inside Qualcomm SoC's.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >  drivers/usb/phy/Kconfig           |   11 ++
> >  drivers/usb/phy/Makefile          |    2 +
> >  drivers/usb/phy/phy-msm-dwc3-hs.c |  327 ++++++++++++++++++++++++++++++++
> >  drivers/usb/phy/phy-msm-dwc3-ss.c |  374 +++++++++++++++++++++++++++++++++++++
> 
> please rename these PHY drivers, they have nothing to do with DWC3. PHYs
> don't care about the USB controller.

I think they are SNPS DesignWare PHY's, additionally
wrapped with Qualcomm logic. I could substitute "dwc3"
with just "dw", which will be more correct.

Regards,
Ivan


