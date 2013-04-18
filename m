Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967673Ab3DRJ53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:57:29 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41169 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3DRJ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:57:25 -0400
Message-ID: <516FC2D1.9020809@linux.vnet.ibm.com>
Date: Thu, 18 Apr 2013 15:24:25 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
CC: akpm@linux-foundation.org, mgorman@suse.de, matthew.garrett@nebula.com,
        dave@sr71.net, rientjes@google.com, riel@redhat.com,
        arjan@linux.intel.com, maxime.coquelin@stericsson.com,
        loic.pallardy@stericsson.com, kamezawa.hiroyu@jp.fujitsu.com,
        lenb@kernel.org, rjw@sisk.pl, gargankita@gmail.com,
        paulmck@linux.vnet.ibm.com, amit.kachhap@linaro.org,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org, wujianguo@huawei.com,
        kmpark@infradead.org, thomas.abraham@linaro.org,
        santosh.shilimkar@ti.com, linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/15][Sorted-buddy] mm: Memory Power Management
References: <20130409214443.4500.44168.stgit@srivatsabhat.in.ibm.com> <516ED378.2000406@linux.intel.com>
In-Reply-To: <516ED378.2000406@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041809-0260-0000-0000-000002D417F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 10:23 PM, Srinivas Pandruvada wrote:
> On 04/09/2013 02:45 PM, Srivatsa S. Bhat wrote:
>> [I know, this cover letter is a little too long, but I wanted to clearly
>> explain the overall goals and the high-level design of this patchset in
>> detail. I hope this helps more than it annoys, and makes it easier for
>> reviewers to relate to the background and the goals of this patchset.]
>>
>>
>> Overview of Memory Power Management and its implications to the Linux MM
>> ========================================================================
>>
[...]
>>
> One thing you need to prevent is boot time allocation. You have to make
> sure that frequently accessed per node data stored at the end of memory
> will keep all ranks of memory active.
> 

I think you meant to say "... stored at the end of memory will NOT keep all
ranks of memory active".

Yep, that's a good point! I'll think about how to achieve that. Thanks!

Regards,
Srivatsa S. Bhat

