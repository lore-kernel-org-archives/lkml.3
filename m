Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3IEOek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:34:40 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:57212 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab3IEOei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:34:38 -0400
Date: Thu, 5 Sep 2013 15:34:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>
Subject: Re: [PATCH V4] regulator: palmas: add support for external control
 of rails
Message-ID: <20130905143431.GI8980@lee--X1>
References: <1377082096-22296-1-git-send-email-ldewangan@nvidia.com>
 <20130823095841.GG25263@sirena.org.uk>
 <522897FD.2030509@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <522897FD.2030509@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Sep 2013, Laxman Dewangan wrote:
> On Friday 23 August 2013 03:28 PM, Mark Brown wrote:
> >* PGP Signed by an unknown key
> >
> >On Wed, Aug 21, 2013 at 04:18:16PM +0530, Laxman Dewangan wrote:
> >>Palmas rails like LDOs, SMPSs, REGENs, SYSENs can be enable and disable
> >>by register programming through I2C communication as well as it can be
> >>enable/disable with the external control input ENABLE1, ENABLE2 and NSLEEP.
> >Acked-by: Mark Brown <broonie@linaro.org>
> >
> 
> Can you please take this in your tree as dependent patch is already
> in your tree?

It won't go in until v3.12 now, but I have applied the patch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
