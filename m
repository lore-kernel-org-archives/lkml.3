Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaHUQEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:04:53 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:35913 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaHUQEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:04:51 -0400
Date: Thu, 21 Aug 2014 12:04:43 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, rui.zhang@intel.com,
        thierry.reding@gmail.com, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/4] ARM: tegra: Add thermal trip points for Jetson TK1
Message-ID: <20140821160442.GB17621@developer>
References: <1407320706-17440-1-git-send-email-mperttunen@nvidia.com>
 <1407320706-17440-4-git-send-email-mperttunen@nvidia.com>
 <53F4FA80.9050103@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F4FA80.9050103@wwwdotorg.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Wed, Aug 20, 2014 at 01:44:00PM -0600, Stephen Warren wrote:
> On 08/06/2014 04:25 AM, Mikko Perttunen wrote:
> > This adds critical trip points to the Jetson TK1 device tree.
> > The device will do a controlled shutdown when either the CPU, GPU
> > or MEM thermal zone reaches 101 degrees Celsius.
> 
> > diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
> 
> > +	thermal-zones {
> > +		cpu {
> > +			trips {
> ...
> > +			};
> > +		};
> 
> thermal.txt states that a cooling-maps sub-node is mandatory. However, 
> it seems to be missing here. Is the DT binding documentation overly 
> strict, or do we need to add such a node here?

I believe the binding documentation is correct. I believe this driver
should still evolve a little bit to accomplish full thermal DT
description and include the cooling devices mapping.

All the best,
