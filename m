Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967690Ab3HINV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:21:29 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5707 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967482Ab3HINV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:21:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 09 Aug 2013 06:19:39 -0700
Message-ID: <1376053269.20259.34.camel@bilhuang-vm1>
Subject: Re: [PATCH RESEND v2 1/1] mfd: palmas: Add power off control
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
Date: Fri, 9 Aug 2013 06:01:09 -0700
In-Reply-To: <20130808123203.GD14515@lee--X1>
References: <1375962305-7438-1-git-send-email-bilhuang@nvidia.com>
	 <20130808123203.GD14515@lee--X1>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 20:32 +0800, Lee Jones wrote:
> On Thu, 08 Aug 2013, Bill Huang wrote:
> 
> > Hook up "pm_power_off" to palmas power off routine if there is DT
> > property "ti,system-power-controller" defined, so platform which is
> > powered by this regulator can be powered off properly.
> > 
> > Signed-off-by: Mallikarjun Kasoju <mkasoju@nvidia.com>
> > Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> > ---
> >  .../devicetree/bindings/regulator/palmas-pmic.txt  |    5 +++
> >  drivers/mfd/palmas.c                               |   33 ++++++++++++++++++--
> >  include/linux/mfd/palmas.h                         |    1 +
> >  3 files changed, 37 insertions(+), 2 deletions(-)
> 
> Was a clear conclusion reached between Nishanth and yourself?
> 
> As he has strong opinions on this I'd ideally like his Ack before
> applying the patch.
> 
Hi Nishanth,

Feel free to NACK if you are feeling this can't fit what you would like
to add, then I'll pass the ball to you for implementing Palmas power off
since you have already wrote part of the driver (with USB IRQ unmask?).


