Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3CKSBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:01:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14156 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3CKSBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:01:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 11 Mar 2013 11:01:17 -0700
Message-ID: <513E1B7E.8090203@nvidia.com>
Date: Mon, 11 Mar 2013 23:29:26 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH V2 4/5] ARM: DT: tegra114: add KBC controller DT entry
References: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com> <1362852678-13421-5-git-send-email-ldewangan@nvidia.com> <513E17C1.1070305@wwwdotorg.org>
In-Reply-To: <513E17C1.1070305@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 March 2013 11:13 PM, Stephen Warren wrote:
> On 03/09/2013 11:11 AM, Laxman Dewangan wrote:
>> NVIDIA's Tegra114 SoCs have the matrix keyboard controller which
>> supports 11x8 type of matrix. The number of rows and columns
>> are configurable.
>>
>> Add DT entry for KBC controller with compatibility as "nvidia,tegra114-kbc",
>> "nvidia,tegra20-kbc".
> I thought the HW really wasn't compatible with Tegra20 due to the
> reduced number of rows/columns/pins supported?

Hw controller is really compatible. Only thing is that there is no 
physical pins on SoC for KBC-ROW11 to KBC-ROW15.
Because, there is no physical pins for ROW11 to ROW15, we asked to 
remove programming/reference this rows from  TRM of T114 to consistent 
with SoCs.

