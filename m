Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaGaKsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:48:22 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5823 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaGaKsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:48:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 31 Jul 2014 03:35:58 -0700
Message-ID: <53DA1EF0.7060207@nvidia.com>
Date: Thu, 31 Jul 2014 13:48:16 +0300
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
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>	<1405088313-20048-6-git-send-email-mperttunen@nvidia.com>	<CAL1qeaGHfjQhLHvgzt85hmbuY4FOG5-k=f80=CNvzPDEgi9_6w@mail.gmail.com>	<53CD860B.7030800@wwwdotorg.org>	<CAL1qeaHtGQxCO3cGdeCRUYuk6mxei6z1B63-iZdBECEbFqGhHw@mail.gmail.com>	<53CE9514.1050903@wwwdotorg.org> <CAL1qeaEkL+mxb0S4JhQbXBjyNyKJndffTSjMaAFQD6ooDJPd+Q@mail.gmail.com> <53CEA093.6060106@wwwdotorg.org> <53D75B90.7050501@nvidia.com> <53D7C276.2080204@wwwdotorg.org>
In-Reply-To: <53D7C276.2080204@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/14 18:49, Stephen Warren wrote:
> On 07/29/2014 02:30 AM, Mikko Perttunen wrote:
>> Looks like the TRM doesn't document this either. I'll add an option
>> ("nvidia,short-ram-code" ?) for the next version.
>
> Using the 2-bit RAM code field as the RAM code is normal operation, so I
> wouldn't call this "short".
>
> Using the 2-bit boot device code field as extra RAM code bits is
> non-standard.
>
> I would suggest nvidia,use-4-bit-ram-code or
> nvidia,use-boot-device-code-as-ram-code-msbs(!) as the property.

Sure.

>
> I see that the TRM implies the whole 4-bit field is RAM code, rather
> than there being 2 separate 2-bit fields for RAM code and boot device
> code. Can you please file a bug against the TRM to document this
> correctly? (The details of which bits are which are visible on the
> Jetson TK1 schematics for example).

Yes, I'll file a bug.

- Mikko
