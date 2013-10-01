Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3JAMJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 08:09:56 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:58760 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab3JAMJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 08:09:54 -0400
Message-ID: <1380629310.30666.22.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v5 1/3] usb: dwc3: msm: Add device tree binding
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
Date: Tue, 01 Oct 2013 15:08:30 +0300
In-Reply-To: <20130923193224.GO30811@radagast>
References: <1377091786-5613-1-git-send-email-iivanov@mm-sol.com>
	 <1377091786-5613-2-git-send-email-iivanov@mm-sol.com>
	 <20130923193224.GO30811@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Mon, 2013-09-23 at 14:32 -0500, Felipe Balbi wrote: 
> Hi,
> 
> On Wed, Aug 21, 2013 at 04:29:44PM +0300, Ivan T. Ivanov wrote:
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
> and here's a new version from same patch

The only difference is that references to "dwc3" are replaced with
just "dw" in USB PHY drivers and file names. This is to indicate
that the PHY's are DesignWare, but not necessarily related to
DWC3 IP core. If you prefer I could keep old abbreviation.

Thanks, 
Ivan


