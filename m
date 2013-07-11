Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3GKIge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:36:34 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6755 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3GKIgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:36:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 11 Jul 2013 01:34:09 -0700
Message-ID: <51DE6E21.7090305@nvidia.com>
Date: Thu, 11 Jul 2013 16:34:41 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ARM: dt: t30 cardhu: add dt entry for nct1008
References: <1373455798-2944-1-git-send-email-wni@nvidia.com> <1373455798-2944-2-git-send-email-wni@nvidia.com> <20130710171319.GB15665@dhcp-172-17-186-34.nvidia.com>
In-Reply-To: <20130710171319.GB15665@dhcp-172-17-186-34.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 01:13 AM, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Wed, Jul 10, 2013 at 07:29:57PM +0800, Wei Ni wrote:
>> Enable thermal sensor nct1008 for t30 cardhu.
> 
> Nit: "Tegra30 Cardhu"
> 
>> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
> [...]
>>  				};
>>  			};
>>  		};
>> +
>> +		nct1008: nct1008 {
> 
> I don't think it's very likely that this chip will need to be referenced
> by a phandle, in which case the "nct1008:" label can be dropped. Even if
> it was used at some point in the future, it's better to add it at that
> time.

Ok, I will remove it.

In the future, I may use this node in the thermal framework, something like:
thermal_zone {
sensor = <&nct1008>;
cooling = <&xxxx>;
....
}
So, at that time I will try to add it again.

Thanks.
Wei.

> 
> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
> 

