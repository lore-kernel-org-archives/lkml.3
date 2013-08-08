Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810Ab3HHCg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:36:29 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13077 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966Ab3HHCg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:36:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 07 Aug 2013 19:34:43 -0700
Message-ID: <52030429.7010400@nvidia.com>
Date: Thu, 8 Aug 2013 10:36:25 +0800
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
Subject: Re: [PATCH 2/2] ARM: dt: t114 dalmore: add dt entry for nct1008
References: <1375858358-15070-1-git-send-email-wni@nvidia.com> <1375858358-15070-3-git-send-email-wni@nvidia.com> <52026FEE.9070003@wwwdotorg.org>
In-Reply-To: <52026FEE.9070003@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 12:03 AM, Stephen Warren wrote:
> On 08/07/2013 12:52 AM, Wei Ni wrote:
>> Enable thermal sensor nct1008 for t114 dalmore.
> 
> Wei, I assume this patch doesn't depend on any of the other LM90-related
> patches you've sent; I can simply apply it right away?

In my [PATCH 1/2], I add codes to get the vdd regulator and enable it,
so if without it, the lm90 can't work properly on Dalmore, although it
can be loaded.
I think it's better to wait my fist patch applied.

> 
> Is the LM90 DT binding fully documented somewhere, including the
> vdd-supply property?

No LM90 DT binding document yet, I will add it in my next version.

> 

