Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab3GKL12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:27:28 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:39327 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab3GKL10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:27:26 -0400
Date: Thu, 11 Jul 2013 12:27:20 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, broonie@kernel.org, ldewangan@nvidia.com,
        sameo@linux.intel.com, grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gg@slimlogic.co.uk
Subject: Re: [PATCH v3 1/4] MFD: Palmas: Check if irq is valid
Message-ID: <20130711112720.GK25601@gmail.com>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <1371621470-22279-2-git-send-email-j-keerthy@ti.com>
 <20130711112531.GJ25601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130711112531.GJ25601@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Lee Jones wrote:

> On Wed, 19 Jun 2013, Keerthy wrote:
> 
> > From: J Keerthy <j-keerthy@ti.com>
> > 
> > Check if irq value obtained is valid. If it is not valid
> > then skip the irq request step and go ahead with the probe.
> > 
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > ---
> >  drivers/mfd/palmas.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> Applied with Stephen and Mark's RB.

Scrap that, it appears to be applied already.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
