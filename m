Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab3KMMNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:13:53 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:43318 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758414Ab3KMMNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:13:51 -0500
Date: Wed, 13 Nov 2013 13:13:32 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: pawel.moll@arm.com, mark.rutland@arm.com, rob@landley.net,
        swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] of: add vendor prefix for GMT
Message-ID: <20131113131332.63068fb1@endymion.delvare>
In-Reply-To: <52835C42.6070806@nvidia.com>
References: <1384340349-8626-1-git-send-email-wni@nvidia.com>
	<52835C42.6070806@nvidia.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 19:02:26 +0800, Wei Ni wrote:
> Previous versions are:
> [v5]: http://patchwork.ozlabs.org/patch/281017/
> [v4]: http://lkml.indiana.edu/hypermail/linux/kernel/1309.1/02812.html
> 
> On 11/13/2013 06:59 PM, Wei Ni wrote:
> > Adding Global Mixed-mode Technology Inc. to the list
> > of devicetree vendor prefixes.
> > 
> > Signed-off-by: Wei Ni <wni@nvidia.com>
> > Acked-by: Stephen Warren <swarren@nvidia.com>
> > ---
> >  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> > index 2956800..64471a8 100644
> > --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> > +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> > @@ -28,6 +28,7 @@ est	ESTeem Wireless Modems
> >  fsl	Freescale Semiconductor
> >  GEFanuc	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
> >  gef	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
> > +gmt	Global Mixed-mode Technology, Inc.
> >  hisilicon	Hisilicon Limited.
> >  hp	Hewlett Packard
> >  ibm	International Business Machines (IBM)
> > 

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
