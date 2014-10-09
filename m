Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaJIHtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:49:24 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19287 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaJIHtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:49:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 09 Oct 2014 00:49:05 -0700
Message-ID: <54363DE8.9030102@nvidia.com>
Date: Thu, 9 Oct 2014 16:48:56 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH 1/2] ARM: tegra: venice2: add GK20A GPU DT node
References: <1412835112-7209-1-git-send-email-acourbot@nvidia.com> <20141009074326.GA1010@ulmo>
In-Reply-To: <20141009074326.GA1010@ulmo>
X-NVConfidentiality: public
X-Originating-IP: [10.19.57.128]
X-ClientProxiedBy: DRBGMAIL104.nvidia.com (10.18.16.23) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 04:43 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Thu, Oct 09, 2014 at 03:11:51PM +0900, Alexandre Courbot wrote:
>> From: Thierry Reding <treding@nvidia.com>
>>
>> Add the device-tree node for the GK20A GPU and leave it disabled by
>> default. It is the responsability of the bootloader to enable it if the
>> VPR registers have been programmed such as the GPU can operate.
>>
>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>   arch/arm/boot/dts/tegra124-venice2.dts | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> Are you going to send the corresponding patches for U-Boot to update
> the status property if it's initialized VPR?

Yes. But maybe I should wait until upstream Nouveau actually works 
properly for that? Right now it will probe successfully, but will crash 
as soon as the GPU is used because there still are memory coherency 
problems.

