Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3GHREa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:04:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15912 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3GHRE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:04:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 08 Jul 2013 10:05:27 -0700
Message-ID: <51DAF30E.9000101@nvidia.com>
Date: Mon, 8 Jul 2013 22:42:46 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ARM: tegra: enable gpio-keys on dalmore
References: <1373102069-5641-1-git-send-email-ldewangan@nvidia.com> <51DADFEC.1050901@wwwdotorg.org>
In-Reply-To: <51DADFEC.1050901@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 July 2013 09:21 PM, Stephen Warren wrote:
> On 07/06/2013 03:14 AM, Laxman Dewangan wrote:
>
>> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
>> @@ -976,4 +1005,5 @@
>>   			 <&tegra_car TEGRA114_CLK_EXTERN1>;
>>   		clock-names = "pll_a", "pll_a_out0", "mclk";
>>   	};
>> +
>>   };
> What's that? I'll try to remember to fix this up when applying, but
> proof-reading would help.

Oops.. My bad.. Did not see the bottom when doing patch review.

Let me know if I need to send V4 if it is easy for you to handle?

