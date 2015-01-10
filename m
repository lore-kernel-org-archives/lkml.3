Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbbAJMIo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 07:08:44 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45816 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbbAJMIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 07:08:42 -0500
Message-ID: <54B1102C.5080901@suse.cz>
Date: Sat, 10 Jan 2015 12:42:36 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dongsu Park <dongsu.park@profitbricks.com>
CC: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kan Liang <kan.liang@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>,
        Mark Davies <junk@eslaf.co.uk>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3.12 11/78] perf/x86/intel: Protect LBR and extra_regs
 against KVM lying
References: <cover.1420799385.git.jslaby@suse.cz> <304ed40ae03a8e72934efc935247780d1b0ada66.1420799385.git.jslaby@suse.cz> <20150110112419.GA4000@posteo.de>
In-Reply-To: <20150110112419.GA4000@posteo.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2015, 12:24 PM, Dongsu Park wrote:
> Hi Jiry,
> 
> On 09.01.2015 11:31, Jiri Slaby wrote:
>> From: Kan Liang <kan.liang@intel.com>
>>
>> 3.12-stable review patch.  If anyone has any objections, please let me know.
> 
> Thanks for taking this patch to 3.12-stable.
> I've just tested 3.12.36 from your stable-3.12-queue tree.
> Unfortunately, the kernel still crashes at intel_pmu_init().
> 
> It turns out that this commit alone is not enough for fixing the bug.
> Actually you also need commit c9b08884c9c98929ec2d8abafd78e89062d01ee7
> ("perf/x86: Correctly use FEATURE_PDCM").
> Can you please pick that commit too?

Now applied, thanks.


-- 
js
suse labs
