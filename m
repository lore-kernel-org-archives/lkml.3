Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3JALvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:51:10 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:57352 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab3JALvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:51:07 -0400
Message-ID: <1380628184.30666.10.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v4 1/3] usb: dwc3: msm: Add device tree binding
 information
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 01 Oct 2013 14:49:44 +0300
In-Reply-To: <20130923193148.GN30811@radagast>
References: <1376992565-22292-1-git-send-email-iivanov@mm-sol.com>
	 <1376992565-22292-2-git-send-email-iivanov@mm-sol.com>
	 <20130923193148.GN30811@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Mon, 2013-09-23 at 14:31 -0500, Felipe Balbi wrote: 
> Hi,
> 
> On Tue, Aug 20, 2013 at 12:56:03PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > MSM USB3.0 core wrapper consist of USB3.0 IP from Synopsys
> > (SNPS) and HS, SS PHY's control and configuration registers.
> > 
> > It could operate in device mode (SS, HS, FS) and host
> > mode (SS, HS, FS, LS).
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> 
> Any acks for the DT part ? This patch has been pending forever.

Thanks you for you patience Felipe. There are also several small
fixups in the driver code that I will like to address. Will send 
updated version with all pending comments shortly.


Regards,
Ivan

