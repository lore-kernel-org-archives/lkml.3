Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaGAFPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 01:15:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39381 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaGAFPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 01:15:50 -0400
Message-ID: <53B2439B.7060001@ti.com>
Date: Tue, 1 Jul 2014 10:44:03 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Nishanth Menon <nm@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Keerthy J <j-keerthy@ti.com>,
        Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2 0/6] regulator: palmas: cleanup and fixes
References: <1404143859-8160-1-git-send-email-nm@ti.com> <53B1C6EC.7070907@wwwdotorg.org>
In-Reply-To: <53B1C6EC.7070907@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2014 01:52 AM, Stephen Warren wrote:
> On 06/30/2014 09:57 AM, Nishanth Menon wrote:
>> Hi,
>> 	Original thread (v1): http://marc.info/?t=140380766500004&r=1&w=2
>> This series is based on: git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git
>> branch: topic/palmas (4c0c9ca Merge remote-tracking branch 'regulator/fix/palmas' into regulator-palmas)
>>
>> This series does a few cleanups to help ensure we dont make typo mistakes and finally provides a fix as attempted by (v1).
>>
>> Basic cpufreq tests performed on OMAP5uEVM, DRA7-evm, DRA72-evm all of which are palmas variants.
>>
>> The patches are also available here: https://github.com/nmenon/linux-2.6-playground/commits/broonie-topic-palmas-fixes
> The series,
> Tested-by: Stephen Warren <swarren@nvidia.com>
>
> (An NVIDIA Dalmore board boots and shuts down OK with these applied on
> top of next-20140630, and various peripherals such as LCD panel, audio,
> USB, and SPI flash all work)
Tested the series on DRA72 board. Checked for all the regulator
and SMPS states and voltages of TPS65917 PMIC.

Tested-by: Keerthy <j-keerthy@ti.com>

Regards,
Keerthy

