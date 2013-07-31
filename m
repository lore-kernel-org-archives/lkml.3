Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527Ab3GaKcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:32:47 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3461 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab3GaKcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:32:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 31 Jul 2013 03:31:19 -0700
Message-ID: <1375267767.32701.6.camel@bilhuang-vm1>
Subject: Re: [PATCH 1/1] mfd: palmas: Add power off control
From: Bill Huang <bilhuang@nvidia.com>
To: Lee Jones <lee.jones@linaro.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "broonie@linaro.org" <broonie@linaro.org>, "nm@ti.com" <nm@ti.com>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Mallikarjun Kasoju" <mkasoju@nvidia.com>
Date: Wed, 31 Jul 2013 03:49:27 -0700
In-Reply-To: <20130731095636.GB13298@lee--X1>
References: <1375185957-28212-1-git-send-email-bilhuang@nvidia.com>
	 <20130731095636.GB13298@lee--X1>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 17:56 +0800, Lee Jones wrote:
> On Tue, 30 Jul 2013, Bill Huang wrote:
> 
> > Hook up "pm_power_off" to palmas power off routine if there is DT
> > property "ti,system-power-controller" defined, so platform which is
> > powered by this regulator can be powered off properly.
> > 
> > Based on work by:
> > Mallikarjun Kasoju <mkasoju@nvidia.com>
> > 
> > Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> > cc: Mallikarjun Kasoju <mkasoju@nvidia.com>
> 
> Please put the 'Cc:' (not 'cc:') above the SoBs, then drop the "Based
> on work by:" and replace with:
> 
> Signed-off-by: Mallikarjun Kasoju <mkasoju@nvidia.com>
> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> 
> This insinuates that the original patch was crated by Mallikarjun.
> 
Thanks, will fix in next version.


