Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaBLUHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:07:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44087 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbaBLUHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:07:45 -0500
Message-ID: <52FBD48E.5070103@wwwdotorg.org>
Date: Wed, 12 Feb 2014 13:07:42 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>, Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH v2 0/6] ARM: firmware: improvements to Trusted Foundations
 support
References: <1391747706-1847-1-git-send-email-acourbot@nvidia.com> <20140212013846.GB7584@quad.lixom.net>
In-Reply-To: <20140212013846.GB7584@quad.lixom.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 06:38 PM, Olof Johansson wrote:
> On Fri, Feb 07, 2014 at 01:35:00PM +0900, Alexandre Courbot wrote:
>> These (mostly minor) patches fix a few typos, improve points that
>> were agreed upon when the Trusted Foundation series was initially
>> submitted, and more importantly add support for a prepare_idle()
>> firmware operation that informs the firmware a CPU is doing idle.
>> Tegra's cpuidle driver is then also updated accordingly.
>>
>> These patches should be the last step before device trees for NVIDIA
>> SHIELD and Tegra Note 7 can be submitted.
>>
>> Changes since v1:
>> - Do not remove TF support from tegra_defconfig (will automatically be taken
>>   care of during next configuration update)
>> - Add a new prepare_idle() operation to firmware_ops that informs the firmware
>>   a CPU is going idle (vs. asking the firmware to do it itself as do_idle()
>>   does)
>> - Fix idle states names in TF implementation of prepare_idle to sound less
>>   Tegra-specific
> 
> 1-5:
> 
> Acked-by: Olof Johansson <olof@lixom.net>
> 
> Stephen asked if he should merge through Russell's tree or ours; since
> tegra is the only user I don't have a problem merging this (via tegra
> pull requests) but I'm giving Russell veto power. :)

Russell, I intend to apply this series to the Tegra tree on Fri US time,
unless I hear otherwise from you. Thanks.
