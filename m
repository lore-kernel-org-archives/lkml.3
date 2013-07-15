Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3GORSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:18:38 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12181 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3GORSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:18:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 15 Jul 2013 10:17:48 -0700
Message-ID: <51E43129.7080602@nvidia.com>
Date: Mon, 15 Jul 2013 22:58:09 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, Rhyland Klein <rklein@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ARM: tegra: enable palmas device for dalmore
References: <1373441852-27176-1-git-send-email-ldewangan@nvidia.com> <51E427D6.7090702@wwwdotorg.org>
In-Reply-To: <51E427D6.7090702@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 July 2013 10:18 PM, Stephen Warren wrote:
> On 07/10/2013 01:37 AM, Laxman Dewangan wrote:
>> Make the entry of Dalmore Power Management Unit device TPS65913
>> in dalmore DTS file. The Palma driver support this device.
>>
>> Enable following submodule of the TPS65913:
>> - GPIO driver
>> - RTC driver.
>> - Power regulator driver.
> If I apply this, (at least) the SD card no longer works. I assume the
> regulator for it is being turned off somehow.

As per downstream power tree, smps9 is feeding power to sd slot and I 
make this rail as always ON. So there should not be any issue.

Rhyland,
Do you see any differences on this power tree with your power tree with 
DT? There was discussion sometime ago on the sdcard. Am I missing 
anything here?

Thanks,
Laxman
