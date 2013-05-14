Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab3ENJT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:19:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35574 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab3ENJT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:19:26 -0400
Message-ID: <5192017D.6060108@ti.com>
Date: Tue, 14 May 2013 14:48:53 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, <gg@slimlogic.co.uk>
CC: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <balbi@ti.com>,
        <ldewangan@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <ruchika@ti.com>, <tony@atomide.com>,
        <sameo@linux.intel.com>
Subject: Re: [PATCH v4] extcon: Palmas Extcon Driver
References: <1362662506-14823-4-git-send-email-kishon@ti.com> <1367846225-15685-1-git-send-email-kishon@ti.com> <20130506144010.GF13472@opensource.wolfsonmicro.com> <51888D55.3090907@ti.com> <20130507075824.GM7478@sirena.org.uk> <5188CD9C.6010602@ti.com> <20130507104502.GQ7478@sirena.org.uk>
In-Reply-To: <20130507104502.GQ7478@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 May 2013 04:15 PM, Mark Brown wrote:
> On Tue, May 07, 2013 at 03:17:08PM +0530, Kishon Vijay Abraham I wrote:
>> On Tuesday 07 May 2013 01:28 PM, Mark Brown wrote:
>
>>>> The platform can provide it's own vbus control in which case this is
>>>> not needed.
>
>>> So why is there no interaction with this external VBUS control and how
>>> does the driver distinguish between that and an error getting the
>>> regulator?
>
>> The platform specifies if it provides its own VBUS control by the dt
>> property ti,no_control_vbus. So the driver will give an error only
>> when *ti,no_control_vbus* is not set. Graeme?
>
> That doesn't answer the question about why there's no interaction with
> the external control...
>

Graeme?

-Kishon
