Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab3CSPzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:55:37 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8756 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3CSPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:55:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Mar 2013 08:55:34 -0700
Message-ID: <51488A75.6000003@nvidia.com>
Date: Tue, 19 Mar 2013 11:55:33 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Anton Vorontsov <anton@enomsg.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [Patch v3 0/4] Add support for tps65090-charger
References: <1363126089-9071-1-git-send-email-rklein@nvidia.com> <20130319022402.GA14118@lizard.gateway.2wire.net>
In-Reply-To: <20130319022402.GA14118@lizard.gateway.2wire.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/2013 10:24 PM, Anton Vorontsov wrote:
> On Tue, Mar 12, 2013 at 06:08:05PM -0400, Rhyland Klein wrote:
>> This patchset adds support for the TPS65090-charger. This charger is
>> registered as a subdevice of the TPS65090 PMIC.
>>
>> This series includes a fix for the tps65090 header file where all
>> the interrupts were shifted by 1.
> 
> Thanks for the patches, Rhyland! 3/4 and 4/4 applied to the
> battery-2.6.git tree.
> 
> Anton
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
I was planning on posting a slightly changed v4 sometime soon which took
care of some concerns on the Documentation and added a compatibility
entry for the charger. Do you want me to send that still and you can
replace v3 with v4?

-rhyland

-- 
nvpublic
