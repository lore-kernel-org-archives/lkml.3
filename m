Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab3GJGzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:55:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1837 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3GJGzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:55:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 09 Jul 2013 23:54:42 -0700
Message-ID: <51DD0757.8060406@nvidia.com>
Date: Wed, 10 Jul 2013 12:33:51 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ARM: tegra: enable gpio-keys on dalmore
References: <1373102069-5641-1-git-send-email-ldewangan@nvidia.com> <20130709060447.GA17499@mithrandir>
In-Reply-To: <20130709060447.GA17499@mithrandir>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 July 2013 11:34 AM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Sat, Jul 06, 2013 at 02:44:29PM +0530, Laxman Dewangan wrote:
>> D
>> +
>> +		home {
>> +			label = "Home";
>> +			gpios = <&gpio TEGRA_GPIO(I, 5) GPIO_ACTIVE_LOW>;
>> +			linux,code = <102>; /* KEY_HOME */
> I wonder if these should maybe go into a header file as well so that
> symbolic names can be used. That'll make the value self-descriptive and
> allow the comment to be dropped.
>
Currently there is no header for input.h in dt-binding include. We need 
to add them first and then use it.
Probably it can be done along with all cleanups on dts file atleast for 
Tegra.
I can start this if no one faster than me for this activity but for this 
patch, I like to go on legacy way.

