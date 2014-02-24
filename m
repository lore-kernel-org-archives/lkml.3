Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaBXJdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:33:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:31818 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbaBXJdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:33:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,533,1389772800"; 
   d="scan'208";a="488625012"
Message-ID: <530B109B.5020901@intel.com>
Date: Mon, 24 Feb 2014 17:27:55 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: tj@kernel.org, oleg@redhat.com, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/Processor: Rework processor throttling with work_on_cpu()
References: <20140220151721.GB32719@redhat.com> <1392960945-30741-1-git-send-email-tianyu.lan@intel.com> <20140221100630.GA1121@krava.brq.redhat.com> <20140221170709.GC1121@krava.brq.redhat.com>
In-Reply-To: <20140221170709.GC1121@krava.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年02月22日 01:07, Jiri Olsa wrote:
> On Fri, Feb 21, 2014 at 11:06:30AM +0100, Jiri Olsa wrote:
>> On Fri, Feb 21, 2014 at 01:35:45PM +0800, Lan Tianyu wrote:
>>> acpi_processor_set_throttling() uses set_cpus_allowed_ptr() to make
>>> sure struct acpi_processor->acpi_processor_set_throttling() callback
>>> run on associated cpu. But the function maybe called in a worker which
>>> has been bound to a cpu. The patch is to replace set_cpus_allowed_ptr()
>>> with work_on_cpu().
>>
>> testing the new patch.. so far so good ;-)
> 
> ook.. survived whole day under the test workload without the warning ;-)
> 
> jirka
> 

Hi Jirka:
	Great. Thanks for test:).


-- 
Best regards
Tianyu Lan
