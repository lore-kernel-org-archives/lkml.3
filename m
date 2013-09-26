Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3IZBPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:15:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:59395 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab3IZBP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:15:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,982,1371106800"; 
   d="scan'208";a="383633107"
Message-ID: <52438AA9.3020809@linux.intel.com>
Date: Wed, 25 Sep 2013 18:15:21 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mgorman@suse.de,
        dave@sr71.net, hannes@cmpxchg.org, tony.luck@intel.com,
        matthew.garrett@nebula.com, riel@redhat.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl,
        gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        santosh.shilimkar@ti.com, kosaki.motohiro@gmail.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Results] [RFC PATCH v4 00/40] mm: Memory Power Management
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com> <52437128.7030402@linux.vnet.ibm.com> <20130925164057.6bbaf23bdc5057c42b2ab010@linux-foundation.org> <20130925234734.GK18242@two.firstfloor.org>
In-Reply-To: <20130925234734.GK18242@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/2013 4:47 PM, Andi Kleen wrote:
>> Also, the changelogs don't appear to discuss one obvious downside: the
>> latency incurred in bringing a bank out of one of the low-power states
>> and back into full operation.  Please do discuss and quantify that to
>> the best of your knowledge.
>
> On Sandy Bridge the memry wakeup overhead is really small. It's on by default
> in most setups today.

btw note that those kind of memory power savings are content-preserving,
so likely a whole chunk of these patches is not actually needed on SNB
(or anything else Intel sells or sold)
