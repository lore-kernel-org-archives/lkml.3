Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbaH0AEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 20:04:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:17404 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695AbaH0AEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 20:04:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,407,1406617200"; 
   d="scan'208";a="563875246"
Message-ID: <53FD205C.8070302@linux.intel.com>
Date: Wed, 27 Aug 2014 08:03:40 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Len Brown <lenb@kernel.org>, Kumar P Mahesh <mahesh.kumar.p@intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] intel_idle: add idle values for Cherrytrail/Braswell
References: <1408701508-13636-1-git-send-email-mika.westerberg@linux.intel.com> <1408707540-12393-1-git-send-email-mika.westerberg@linux.intel.com> <53F74E5D.2040108@linux.intel.com> <20140825101200.GH1660@lahna.fi.intel.com> <53FBF328.1080205@linux.intel.com> <20140826090032.GN1660@lahna.fi.intel.com>
In-Reply-To: <20140826090032.GN1660@lahna.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/26 17:00, Mika Westerberg wrote:
> On Tue, Aug 26, 2014 at 10:38:32AM +0800, Li, Aubrey wrote:
>> On 2014/8/25 18:12, Mika Westerberg wrote:
>>> On Fri, Aug 22, 2014 at 10:06:21PM +0800, Li, Aubrey wrote:
>>>> On 2014/8/22 19:39, Mika Westerberg wrote:
>>>>> From: Mahesh Kumar P <mahesh.kumar.p@intel.com>
>>>>>
>>>>> Cherrytrail/Braswell is a successor of Intel Baytrail but has slighly
>>>>> different CPU idle values and latencies.
>>>>>
>>>>> Signed-off-by: Kumar P Mahesh <mahesh.kumar.p@intel.com>
>>>>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>>>>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>>>>> ---
>>>>> I learned from Mahesh that C1e, C4 and S0i2 states are deprecated so those
>>>>> are now removed.
>>>>
>>>> If the platform has ACPI supported, I believe Len wants to see what
>>>> C-states number exported by ACPI.
>>>>
>>>> Please boot the machine with "intel_idle.max_cstate=0" to disable
>>>> intel_idle, then post the output of the following commands
>>>
>>> OK, here goes:
>>
>> ACPI exposes 0x58 as C6 mwait hint while the patch proposes 0x52 for C6.
>> Can you please remove "intel_idle.max_cstate=0" and run "dmesg | grep
>> idle" again to see how many C6 supports in CPUID enumeration?
> 
> [   16.685769] intel_idle: MWAIT substates: 0x33000020
> [   16.691236] intel_idle: v0.4 model 0x4C
> [   16.695539] intel_idle: lapic_timer_reliable_states 0xffffffff
> 

enough to turn over to Len to finalize, thanks Mika.

-Aubrey

