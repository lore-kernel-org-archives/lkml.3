Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbaHNOVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:21:24 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:37422 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbaHNOVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:21:23 -0400
Message-ID: <53ECC5E2.5080903@akamai.com>
Date: Thu, 14 Aug 2014 10:21:22 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "srinivas.pandruvada@linux.intel.com" 
	<srinivas.pandruvada@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powercap/rapl: add support for cpu model 0x3f
References: <20140813203326.957F58004E@prod-mail-relay07.akamai.com> <20140813155035.2af00ef5@ultegra>
In-Reply-To: <20140813155035.2af00ef5@ultegra>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 06:50 PM, Jacob Pan wrote:
> On Wed, 13 Aug 2014 20:33:26 +0000 (GMT)
> Jason Baron <jbaron@akamai.com> wrote:
> 
>> I've confirmed that monitoring the package power usage as well
>> as setting power limits appear to be working as expected. However,
>> I do see in the logs:
>>
>> [    5.082632] intel_rapl: RAPL domain core detection failed
>> [    5.088370] intel_rapl: RAPL domain uncore detection failed
>>
>> So I'm not sure if the h/w simply doesn't support that, or if the
>> driver could be improved here. In any case, adding the 0x3f makes
>> the driver useful for me. Tested aginst cpu:
>>
>> Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz
>>
> I don't have this CPU model to test. Most server processors don't
> have uncore domain so detection failed is normal. Looks like you just
> have package and dram domain?

Yes.

> Thanks for testing it out, looks good to me. can you send it to
> linux-pm list and cc rafael?
> 

Ok.

Thanks,

-Jason

