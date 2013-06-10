Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3FJLDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:03:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48226 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab3FJLDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:03:33 -0400
Message-ID: <51B5B268.8090908@ti.com>
Date: Mon, 10 Jun 2013 16:33:04 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "balbi@ti.com" <balbi@ti.com>
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
References: <20130530113247.GI5180@sirena.org.uk> <51A74D70.5060303@nvidia.com> <20130601184511.GC16790@sirena.org.uk> <51AA456E.3030307@nvidia.com> <20130601210511.GT16790@sirena.org.uk> <51ADAE78.4050900@ti.com> <20130604093816.GY31367@sirena.org.uk> <51ADB6BF.6020205@ti.com> <20130604100511.GA31367@sirena.org.uk> <51B5A14E.6000500@ti.com> <20130610100330.GO31367@sirena.org.uk>
In-Reply-To: <20130610100330.GO31367@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 10 June 2013 03:33 PM, Mark Brown wrote:
> On Mon, Jun 10, 2013 at 03:20:06PM +0530, Kishon Vijay Abraham I wrote:
>> On Tuesday 04 June 2013 03:35 PM, Mark Brown wrote:
>>> On Tue, Jun 04, 2013 at 03:13:27PM +0530, Kishon Vijay Abraham I wrote:
>>>> On Tuesday 04 June 2013 03:08 PM, Mark Brown wrote:
>
>>>>> No.  A boost regulator is still a voltage regulator, it just happens to
>>>>> raise rather than lower the voltage but it's otherwise a normal
>>>>> regulator.  I'm not sure what you mean by "SWITCH" - from the name it'd
>>>>> just be a bypass?
>
>> SMPS10 has two outputs OUT2 and OUT1. In order to connect OUT2 to
>> OUT1 we have to set "SWITCH_EN" bit in SMPS10_CTRL register.
>
> Is that not just a normal enable?

IIUC, normal enable should be when output is driven through OUT2.

Thanks
Kishon
