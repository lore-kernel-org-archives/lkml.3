Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967224Ab3HIGKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:10:19 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6089 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934306Ab3HIGKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:10:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 08 Aug 2013 23:10:17 -0700
Message-ID: <520487C7.5080901@nvidia.com>
Date: Fri, 9 Aug 2013 14:10:15 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] Documentation: dt: hwmon: add OF document for
 lm90
References: <1375944991-29182-1-git-send-email-wni@nvidia.com> <1375944991-29182-4-git-send-email-wni@nvidia.com> <5203D757.8000208@wwwdotorg.org>
In-Reply-To: <5203D757.8000208@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 01:37 AM, Stephen Warren wrote:
> On 08/08/2013 12:56 AM, Wei Ni wrote:
>> Add OF document for lm90 in Documentation/devicetree/.
> 
>> diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt b/Documentation/devicetree/bindings/hwmon/lm90.txt
> 
>> +Required node properties:
>> +- compatible: manufacture and chip name,
>> +              which are listed in the Documentation/hwmon/lm90
> 
> You need to specify the exact values here. DT binding documentations
> should be OS-agnostic, and hence can't depend on Linux-specific
> documentation or other details.

Ok, I will list it.

> 
>> +Optional properties:
>> +- vdd-supply: vdd regulator for the supply voltage. If this is not set,
> 
> s/set/present/.

Oh, yes, I will change it.

> 
>> +- interrupts: lm90 can support interrupt mode, you can set interrupt here.
> 
> You might want to mention that a single entry ("specifier") is expected
> in the list.

Sorry, I didn't get your point, could you explain more?

> 

