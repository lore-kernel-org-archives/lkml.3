Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3HCAQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 20:16:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:7699 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab3HCAQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 20:16:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,805,1367996400"; 
   d="scan'208";a="381059659"
Message-ID: <51FC4D9F.1070302@linux.intel.com>
Date: Fri, 02 Aug 2013 17:23:59 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [RFC v01 1/3] PowerCap: Documentation
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>  <1375466932-11842-2-git-send-email-srinivas.pandruvada@linux.intel.com> <1375488644.2034.150.camel@joe-AO722>
In-Reply-To: <1375488644.2034.150.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 05:10 PM, Joe Perches wrote:
> On Fri, 2013-08-02 at 11:08 -0700, Srinivas Pandruvada wrote:
>> Added power cap framework documentation. This explains the use of power capping framework,
>> sys-fs and programming interface.
> []
Didn't understand this comment.
>> +Power Zone Attributes
>> +=================================
>> +Monitoring attributes
>> +----------------------
>> +	
>> +energy_uj (rw): Current energy counter in micro-joules. Write to energy counter
>> +resets the counter to zero. If the counter can not be reset, then this attribute
>> +is read-only.
>> +
>> +max_energy_range_uj (ro): Range of the above energy counter in micro-joules.
>> +
>> +power_uw (rw): Current power counter in micro-watts. Write to this counter
>> +resets the counter to zero. If the counter can not be reset, then this attribute
>> +is read-only.
>> +max_power_range_uw (ro): Range of the above energy counter in micro-watts.
>> +
>> +It is possible that some domains can have both power and energy counters and
>> +ranges, but at least one is mandatory.
> Given that the ranges seem to be u64s, perhaps the
> lower bounds are too high.  Why not nano/pico/fempto
> watts/joules/seconds?
I think they are too small to realistically set a limits on power or 
measure. Let's see what others think.
>
>
Thanks,
Srinivas
