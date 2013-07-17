Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab3GQIrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:47:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9347 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3GQIrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:47:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 17 Jul 2013 01:47:33 -0700
Message-ID: <51E65C74.8060405@nvidia.com>
Date: Wed, 17 Jul 2013 14:27:24 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ARM: tegra: enable palmas device for dalmore
References: <1373441852-27176-1-git-send-email-ldewangan@nvidia.com> <51E54FD1.1010404@nvidia.com>
In-Reply-To: <51E54FD1.1010404@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 July 2013 07:21 PM, Mikko Perttunen wrote:
> On 07/10/2013 10:37 AM, Laxman Dewangan wrote:
>> +
>> +			palmas_gpio: gpio {
>> +				compatible = "ti,palmas-gpio";
>> +				gpio-controller;
>> +				#gpio-cells = <2>;
>> +			};
> I don't think the palmas-gpio driver ever gets probed since it doesn't
> have device tree compability strings?
>
You will need the patch
[PATCH V3] gpio: palmas: add dt support

which is under review from last few days.

