Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaCNXzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 19:55:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbaCNXzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 19:55:37 -0400
Date: Fri, 14 Mar 2014 23:56:37 +0000
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Julien Grall <julien.grall@linaro.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, xen-devel@lists.xenproject.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] arm/xen: Don't use xen DMA ops when the device is
 protected by an IOMMU
Message-ID: <20140314235637.GA5687@kroah.com>
References: <1392913301-25524-1-git-send-email-julien.grall@linaro.org>
 <1392914159.32657.18.camel@kazak.uk.xensource.com>
 <alpine.DEB.2.02.1402241214570.4471@kaball.uk.xensource.com>
 <20140224151636.GA13489@kroah.com>
 <alpine.DEB.2.02.1402242036490.31489@kaball.uk.xensource.com>
 <5323334F.90700@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5323334F.90700@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 04:50:23PM +0000, Julien Grall wrote:
> On 02/24/2014 08:49 PM, Stefano Stabellini wrote:
> > On Mon, 24 Feb 2014, gregkh@linuxfoundation.org wrote: 
> > Julien is proposing to store the list of "safe" devices on an hash table
> > in the Xen specific code (in arch/arm/xen/enlighten.c, see
> > http://marc.info/?l=linux-kernel&m=139291370526082&w=2).
> > Whenever Linux is about to do DMA, we would check in the hashtable to
> > figure out whether we need to go through the swiotlb or we can simply
> > use the native dma_ops.
> > 
> > Ian and I were thinking that it would be much easier and faster to have
> > a "xen_safe_device" parameter in struct device and just check for that.
> > It doesn't actually need to be in struct device, it could simply be a
> > flag in struct device_dma_parameters as Ian was suggesting.
> > 
> > Julien, could you please come up with a simple patch to demonstrate the
> > concept?
> 
> Hello Stefano and Greg,
> 
> Sorry for the late answer. I wrote a simple patch which depend on patch #1.
> Let me know if it's the right direction.

I have no context here, care to start the patch series over?

thanks,

greg k-h
