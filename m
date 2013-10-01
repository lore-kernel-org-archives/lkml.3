Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3JAMGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 08:06:40 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:58498 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3JAMGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 08:06:37 -0400
Message-ID: <1380629114.30666.19.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v5 1/3] usb: dwc3: msm: Add device tree binding
 information
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: balbi@ti.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, ian.campbell@citrix.com, rob@landley.net,
        gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 01 Oct 2013 15:05:14 +0300
In-Reply-To: <5240BAA6.9090509@wwwdotorg.org>
References: <1377091786-5613-1-git-send-email-iivanov@mm-sol.com>
	 <1377091786-5613-2-git-send-email-iivanov@mm-sol.com>
	 <20130923193224.GO30811@radagast> <5240BAA6.9090509@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

On Mon, 2013-09-23 at 16:03 -0600, Stephen Warren wrote: 
> On 09/23/2013 01:32 PM, Felipe Balbi wrote:
> > Hi,
> > 
> > On Wed, Aug 21, 2013 at 04:29:44PM +0300, Ivan T. Ivanov wrote:
> >> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >> 
> >> MSM USB3.0 core wrapper consist of USB3.0 IP from Synopsys (SNPS)
> >> and HS, SS PHY's control and configuration registers.
> >> 
> >> It could operate in device mode (SS, HS, FS) and host mode (SS,
> >> HS, FS, LS).
> >> 
> >> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > 
> > and here's a new version from same patch
> 
> The binding looks pretty simple, so I don't think it's too contentious.
> 
> >> diff --git a/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> >> b/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> 
> >> +MSM DWC3 controller wrapper
> 
> >> +Optional properties : +- gdsc-supply : phandle to the globally
> >> distributed switch controller +  regulator node to the USB
> >> controller.
> 
> If that's a regulator node, why not use xxx-supply properties to
> interface with it?

That was the intention. What about:

Optional "supply-name" :
    "gdsc" - supply from globally distributed switch controller


> 
> Aside from that, the binding,
> Acked-by: Stephen Warren <swarren@nvidia.com>

Thank you.

Regards,
Ivan

