Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964911Ab3HIPOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:14:37 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:56407 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934350Ab3HIPOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:14:34 -0400
Message-ID: <1376061400.6143.1.camel@debian>
Subject: Re: [RFC PATCH v2 3/3] usb: dwc3: Add Qualcomm DWC3 glue layer
 driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Fri, 09 Aug 2013 11:16:40 -0400
In-Reply-To: <20130809133213.GJ12041@radagast>
References: <1376042027-9798-1-git-send-email-iivanov@mm-sol.com>
	 <1376042027-9798-4-git-send-email-iivanov@mm-sol.com>
	 <20130809133213.GJ12041@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Fri, 2013-08-09 at 16:32 +0300, Felipe Balbi wrote:
> On Fri, Aug 09, 2013 at 12:53:47PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > DWC3 glue layer is hardware layer around Synopsys DesignWare
> > USB3 core. Its purpose is to supply Synopsys IP with required
> > clocks, voltages and interface it with the rest of the SoC.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> 
> same comments from previous version.
> 

Sorry, I have somehow missed Your email.
I will address them shortly.

Regard,
Ivan

