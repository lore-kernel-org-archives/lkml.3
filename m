Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3IEOWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:22:11 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16671 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3IEOWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:22:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Sep 2013 07:19:14 -0700
Message-ID: <522897FD.2030509@nvidia.com>
Date: Thu, 5 Sep 2013 20:11:01 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: Mark Brown <broonie@kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "rob@landley.net" <rob@landley.net>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>
Subject: Re: [PATCH V4] regulator: palmas: add support for external control
 of rails
References: <1377082096-22296-1-git-send-email-ldewangan@nvidia.com> <20130823095841.GG25263@sirena.org.uk>
In-Reply-To: <20130823095841.GG25263@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Friday 23 August 2013 03:28 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Wed, Aug 21, 2013 at 04:18:16PM +0530, Laxman Dewangan wrote:
>> Palmas rails like LDOs, SMPSs, REGENs, SYSENs can be enable and disable
>> by register programming through I2C communication as well as it can be
>> enable/disable with the external control input ENABLE1, ENABLE2 and NSLEEP.
> Acked-by: Mark Brown <broonie@linaro.org>
>

Can you please take this in your tree as dependent patch is already in 
your tree?

Thanks,
Laxman

