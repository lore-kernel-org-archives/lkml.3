Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaDPHEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:04:44 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:58509 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754716AbaDPHEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:04:42 -0400
Message-ID: <534E2B87.10304@semaphore.gr>
Date: Wed, 16 Apr 2014 10:04:39 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-sh@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] sh: clk: Use cpufreq_for_each_valid_entry macro
 for iteration
References: <534DB238.5030201@semaphore.gr> <20140416041345.GC27534@verge.net.au>
In-Reply-To: <20140416041345.GC27534@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/2014 07:13 πμ, Simon Horman wrote:
> On Wed, Apr 16, 2014 at 01:27:04AM +0300, Stratos Karafotis wrote:
>> The cpufreq core now supports the cpufreq_for_each_valid_entry macro
>> helper for iteration over the cpufreq_frequency_table, so use it.
>>
>> It should have no functional changes.
>>
>> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> 
> Rafael, please feel free to take this one.
> 
> Acked-by: Simon Horman <horms+renesas@verge.net.au>
> 

Thanks!

Stratos

