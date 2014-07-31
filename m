Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaGaLF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:05:59 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12436 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaGaLF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:05:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 31 Jul 2014 03:57:31 -0700
Message-ID: <53DA230E.7060903@nvidia.com>
Date: Thu, 31 Jul 2014 14:05:50 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Andrew Bresticker <abrestic@chromium.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>	<1405088313-20048-6-git-send-email-mperttunen@nvidia.com>	<CAL1qeaGHfjQhLHvgzt85hmbuY4FOG5-k=f80=CNvzPDEgi9_6w@mail.gmail.com>	<53CD860B.7030800@wwwdotorg.org>	<CAL1qeaHtGQxCO3cGdeCRUYuk6mxei6z1B63-iZdBECEbFqGhHw@mail.gmail.com>	<53CE9514.1050903@wwwdotorg.org> <CAL1qeaEkL+mxb0S4JhQbXBjyNyKJndffTSjMaAFQD6ooDJPd+Q@mail.gmail.com> <53CEA093.6060106@wwwdotorg.org> <53D75B90.7050501@nvidia.com> <53D7C276.2080204@wwwdotorg.org> <53DA1EF0.7060207@nvidia.com>
In-Reply-To: <53DA1EF0.7060207@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/14 13:48, Mikko Perttunen wrote:
>>
>> I see that the TRM implies the whole 4-bit field is RAM code, rather
>> than there being 2 separate 2-bit fields for RAM code and boot device
>> code. Can you please file a bug against the TRM to document this
>> correctly? (The details of which bits are which are visible on the
>> Jetson TK1 schematics for example).
>
> Yes, I'll file a bug.

On a closer look, the downstream kernel has been recently updated to 
consider the whole 4 bits the ram code. The relevant bug also has a 
comment mentioning that starting from T124, the whole 4 bits is 
considered the RAM code.

>
> - Mikko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
