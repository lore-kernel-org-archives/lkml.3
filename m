Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3LDFwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 00:52:34 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13170 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab3LDFwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 00:52:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 03 Dec 2013 21:45:52 -0800
Message-ID: <529EC27C.6030003@nvidia.com>
Date: Wed, 4 Dec 2013 11:19:48 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: dts: tegra: Header file for pinctrl constants
References: <1385992502-12771-1-git-send-email-ldewangan@nvidia.com> <20131202142522.GA17566@ulmo.nvidia.com> <529D745D.2070503@nvidia.com> <529E3A34.4030206@wwwdotorg.org>
In-Reply-To: <529E3A34.4030206@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 December 2013 01:38 AM, Stephen Warren wrote:
> On 12/02/2013 11:04 PM, Laxman Dewangan wrote:
>> On Monday 02 December 2013 07:55 PM, Thierry Reding wrote:
>>> * PGP Signed by an unknown key
>>>
>>> On Mon, Dec 02, 2013 at 07:25:01PM +0530, Laxman Dewangan wrote:
>>>
>>> +
>>> +/* Schmitt enable/disable */
>>> +#define TEGRA_PIN_DRIVE_SCHMITT_DISABLE            0
>>> +#define TEGRA_PIN_DRIVE_SCHMITT_ENABLE            1
>>> These are all boolean, so I wonder if perhaps we should be simply
>>> defining a single pair and reuse that in different contexts:
>>>
>>>      #define TEGRA_PIN_DISABLE    0
>>>      #define TEGRA_PIN_ENABLE    1
>>>
>>> The property names should provide enough context for them to be used
>>> unambiguously.
>>>
>>>
>> I can make generic ENABLE/DISABLE macro as you suggested but datasheet
>> says as 0=NORMAL, 1 = TRISTATE. and that's why I kept name very near to
>> the datasheet.
> That documentation is relative to a specific field, whereas the
> namespace for #defines is global. Hence, we may have to name #defines
> using stricter rules than the TRM's field values, in order to make them
> unambiguous.

I send the V2 patches on which I have taken care of this.
Request you to please review.

Thanks,
Laxman
