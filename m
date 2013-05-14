Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab3ENSsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:48:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17032 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091Ab3ENSsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:48:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 14 May 2013 11:48:38 -0700
Message-ID: <519285B6.2090701@nvidia.com>
Date: Wed, 15 May 2013 00:13:02 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Graeme Gregory <gg@slimlogic.co.uk>
CC: Kishon Vijay Abraham I <kishon@ti.com>, Mark Brown <broonie@kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>, "ruchika@ti.com" <ruchika@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Subject: Re: [PATCH v4] extcon: Palmas Extcon Driver
References: <1362662506-14823-4-git-send-email-kishon@ti.com> <1367846225-15685-1-git-send-email-kishon@ti.com> <20130506144010.GF13472@opensource.wolfsonmicro.com> <51888D55.3090907@ti.com> <20130507075824.GM7478@sirena.org.uk> <5188CD9C.6010602@ti.com> <20130507104502.GQ7478@sirena.org.uk> <5192017D.6060108@ti.com> <20130514095402.GA9721@xora-build.xora.org.uk>
In-Reply-To: <20130514095402.GA9721@xora-build.xora.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 May 2013 03:24 PM, Graeme Gregory wrote:
> On Tue, May 14, 2013 at 02:48:53PM +0530, Kishon Vijay Abraham I wrote:
>> On Tuesday 07 May 2013 04:15 PM, Mark Brown wrote:
>>> On Tue, May 07, 2013 at 03:17:08PM +0530, Kishon Vijay Abraham I wrote:
>>>> On Tuesday 07 May 2013 01:28 PM, Mark Brown wrote:
>>>>>> The platform can provide it's own vbus control in which case this is
>>>>>> not needed.
>>>>> So why is there no interaction with this external VBUS control and how
>>>>> does the driver distinguish between that and an error getting the
>>>>> regulator?
>>>> The platform specifies if it provides its own VBUS control by the dt
>>>> property ti,no_control_vbus. So the driver will give an error only
>>>> when *ti,no_control_vbus* is not set. Graeme?
>>> That doesn't answer the question about why there's no interaction with
>>> the external control...
>>>
>> Graeme?
>>
> I already partially answered this, it was written for a SoC where VBUS
> generation was in hardware on the SoC with no information.
>
> I would say if nvidia/Laxman do not need this remove it, if someone ever
> uses it then they can re-add it easy enough!

I think we really do not require this. Just we need the notification 
through extcon about the cable connection. We should remove it for 
avoiding complexity for now.

