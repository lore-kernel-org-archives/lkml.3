Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628Ab3GaRSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:18:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44559 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760452Ab3GaRSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:18:03 -0400
Message-ID: <51F946C7.2080205@wwwdotorg.org>
Date: Wed, 31 Jul 2013 11:17:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Bill Huang <bilhuang@nvidia.com>, sameo@linux.intel.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob@landley.net, broonie@linaro.org,
        nm@ti.com, j-keerthy@ti.com, grant.likely@linaro.org,
        ian@slimlogic.co.uk, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Subject: Re: [PATCH 1/1] mfd: palmas: Add power off control
References: <1375185957-28212-1-git-send-email-bilhuang@nvidia.com> <20130731095636.GB13298@lee--X1>
In-Reply-To: <20130731095636.GB13298@lee--X1>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 03:56 AM, Lee Jones wrote:
> On Tue, 30 Jul 2013, Bill Huang wrote:
> 
>> Hook up "pm_power_off" to palmas power off routine if there is DT
>> property "ti,system-power-controller" defined, so platform which is
>> powered by this regulator can be powered off properly.
>>
>> Based on work by:
>> Mallikarjun Kasoju <mkasoju@nvidia.com>
>>
>> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
>> cc: Mallikarjun Kasoju <mkasoju@nvidia.com>
> 
> Please put the 'Cc:' (not 'cc:') above the SoBs, then drop the "Based
> on work by:" and replace with:
> 
> Signed-off-by: Mallikarjun Kasoju <mkasoju@nvidia.com>
> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> 
> This insinuates that the original patch was crated by Mallikarjun.

That advice may not be correct. Did Mallikarjun actually create *this*
patch? More likely, this patch was based on an equivalent change to some
other PMIC, and Bill just applied the same technique to this other
driver. If Mallikarjun really did write this patch, then the git author
field should also be set to Mallikarjun not Bill.
