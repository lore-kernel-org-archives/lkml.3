Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3AWQhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:37:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40359 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3AWQhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:37:47 -0500
Message-ID: <510011D7.3000301@wwwdotorg.org>
Date: Wed, 23 Jan 2013 09:37:43 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex
 A9
References: <50FE2CA8.20100@ti.com><50FEC503.2080602@wwwdotorg.org><20130123.080457.171573168772211248.hdoyu@nvidia.com> <20130123.112745.1104072242042163713.hdoyu@nvidia.com>
In-Reply-To: <20130123.112745.1104072242042163713.hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 02:27 AM, Hiroshi Doyu wrote:
> Hiroshi Doyu <hdoyu@nvidia.com> wrote @ Wed, 23 Jan 2013 08:04:57 +0200 (EET):
> 
>> Stephen Warren <swarren@wwwdotorg.org> wrote @ Tue, 22 Jan 2013 17:57:39 +0100:
>>
>>> Hiroshi, is this series the only dependency you need for your
>>> Tegra114
>>
>> Basically yes.
>>
>>> series? So, I could merge your Tegra114 series once this series is applied?
>>
>> But now "CCF" seems to be in. Then, the HACK(*1) needs to be replaced
>> with "Tegra114 CCF". But "Tegra114 CCF" doesn't seem ready yet. I'll check
>> if this Tegra114 series would work without "Tegra114 CCF".
>>
>> *1: http://patchwork.ozlabs.org/patch/212010/
> 
> Stephen,
> 
> Verified "Tegra114 series" worked with "for-3.9/soc" branch(inc CCF)
> with a little tweak.

Good news.

> I can post Tegra114 series again. If you want them rebased onto
> another branch, let me know.

Yes please. I will apply them to for-3.9/soc. Please assume that
for-3.9/soc will already contain "ARM: Define CPU part numbers and
implementors", and your two SCU-related patches. Include your "ARM:
tegra: Use DT /cpu node to detect number of CPU core" as the first patch
in the series. I assume that is all of the dependencies; if I've
forgotten anything, please point it out. Thanks.
