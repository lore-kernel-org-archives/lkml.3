Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3JYWaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 18:30:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:24878 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab3JYWaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 18:30:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="312857449"
Message-ID: <526AF0F8.6030100@linux.intel.com>
Date: Fri, 25 Oct 2013 15:30:16 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Mark Brown <broonie@kernel.org>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: linux-next: Tree for Oct 25 (powercap_sys.c)
References: <1382713426-2680-1-git-send-email-treding@nvidia.com> <526ACA95.9030904@infradead.org> <526AEE08.5080706@linux.intel.com>
In-Reply-To: <526AEE08.5080706@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ignore my patch. Already a patch by Thierry Reding is in PM next tree.

Thanks,
Srinivas


On 10/25/2013 03:17 PM, Srinivas Pandruvada wrote:
>
> On 10/25/2013 12:46 PM, Randy Dunlap wrote:
>> On 10/25/13 08:03, Thierry Reding wrote:
>>> Hi all,
>>>
>>> I've uploaded today's linux-next tree to the master branch of the
>>> repository below:
>>>
>>>          git://gitorious.org/thierryreding/linux-next.git
>>>
>>> A next-20131025 tag is also provided for convenience.
>>>
>>> One new trivial conflicts and a new build failure caused by an 
>>> incorrect
>>> use of the genpool allocator.
>>>
>>> Upon a request from Olof Johansson I've only included fixes for build
>>> breakage as a result of interactions between the various trees. But
>>> since I've fixed many of the other build failures already, I've pushed
>>> those to a separate tag (next-20131025-fixes). That builds fine on x86
>>> 32-bit and 64-bit allmodconfigs as well as ARM and x86 default
>>> configurations. Most of the PowerPC build errors have also been fixed.
>> on i386:
>>
>> drivers/powercap/powercap_sys.c:484:2: error: unknown field 
>> 'dev_attrs' specified in initializer
>> drivers/powercap/powercap_sys.c:484:2: warning: initialization from 
>> incompatible pointer type [enabled by default]
>> drivers/powercap/powercap_sys.c:484:2: warning: (near initialization 
>> for 'powercap_class.suspend') [enabled by default]
> Submitted patch and copied to you all.
>
> Thanks,
> Srinivas
>

