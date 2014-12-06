Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaLFLnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 06:43:42 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:54325 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaLFLnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 06:43:41 -0500
Message-ID: <5482EBE4.2050602@collabora.co.uk>
Date: Sat, 06 Dec 2014 12:43:32 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: Mark Brown <broonie@kernel.org>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: dts: Configure regulators for suspend on exynos
 Peach boards
References: <1415707485-28563-1-git-send-email-javier.martinez@collabora.co.uk> <1415707485-28563-4-git-send-email-javier.martinez@collabora.co.uk> <5464198D.9030608@samsung.com>
In-Reply-To: <5464198D.9030608@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

On 11/13/2014 03:38 AM, Kukjin Kim wrote:
> On 11/11/14 21:04, Javier Martinez Canillas wrote:
>> The regulator core now has support to choose if a regulator
>> has to be enabled or disabled during system suspend and also
>> supports changing the regulator operating mode during runtime
>> and when the system enters into sleep mode.
>>
>> To lower power during suspend, configure the regulators state
>> using the same configuration found in the ChromeOS 3.8 kernel.
>>
> Basically I'm fine on this dt changes but this should be queued after 
> confirming 1st and 2nd on this series from regulator maintainer...
> 
> Once they are landing into regulator tree, I will apply this.
> 

Mark already applied the patches from the 1st and 2nd series in the
topic/suspend and topic/max77802 branches of his regulator tree [0].

So I think is safe for you to pick this patch now.

Thanks a lot and best regards,
Javier

[0]: git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git
