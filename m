Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab3HLNwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:52:16 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44549 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab3HLNwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:52:11 -0400
Date: Mon, 12 Aug 2013 14:52:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Bill Huang <bilhuang@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Subject: Re: [PATCH RESEND v2 1/1] mfd: palmas: Add power off control
Message-ID: <20130812135201.GE13851@lee--X1>
References: <1375962305-7438-1-git-send-email-bilhuang@nvidia.com>
 <20130808123203.GD14515@lee--X1>
 <1376053269.20259.34.camel@bilhuang-vm1>
 <520500F2.2000200@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <520500F2.2000200@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Aug 2013, Nishanth Menon wrote:

> On 08/09/2013 08:01 AM, Bill Huang wrote:
> >On Thu, 2013-08-08 at 20:32 +0800, Lee Jones wrote:
> >>On Thu, 08 Aug 2013, Bill Huang wrote:
> >>
> >>>Hook up "pm_power_off" to palmas power off routine if there is DT
> >>>property "ti,system-power-controller" defined, so platform which is
> >>>powered by this regulator can be powered off properly.
> >>>
> >>>Signed-off-by: Mallikarjun Kasoju <mkasoju@nvidia.com>
> >>>Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> >>>---
> >>>  .../devicetree/bindings/regulator/palmas-pmic.txt  |    5 +++
> >>>  drivers/mfd/palmas.c                               |   33 ++++++++++++++++++--
> >>>  include/linux/mfd/palmas.h                         |    1 +
> >>>  3 files changed, 37 insertions(+), 2 deletions(-)
> >>
> >>Was a clear conclusion reached between Nishanth and yourself?
> >>
> >>As he has strong opinions on this I'd ideally like his Ack before
> >>applying the patch.
> >>
> >Feel free to NACK if you are feeling this can't fit what you would like
> >to add, then I'll pass the ball to you for implementing Palmas power off
> >since you have already wrote part of the driver (with USB IRQ unmask?).
> Apologies on the delay in review. As long as we are ok with not
> having a drivers/power/reset driver, I can buy this as a step #1.
> USB IRQ unmask could go on top of it.
> 
> Other than that,
> Acked-by: Nishanth Menon <nm@ti.com>

Applied with Nishanth's Ack, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
