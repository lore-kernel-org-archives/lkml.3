Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaCJCkt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 22:40:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:44146 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbaCJCkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 22:40:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,621,1389772800"; 
   d="scan'208";a="469344467"
Message-ID: <531D2623.1030200@linux.intel.com>
Date: Sun, 09 Mar 2014 19:40:35 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>, Russ Anderson <rja@sgi.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [GIT PULL] x86 fixes for v3.14-rc6 - bad patch dropped
References: <201403100015.s2A0FM4Z015106@terminus.zytor.com> <CA+55aFx36NkGNSNdLfyrdFAv2s_Ay6wUCoh57H-XR0o+vzT2Fw@mail.gmail.com>
In-Reply-To: <CA+55aFx36NkGNSNdLfyrdFAv2s_Ay6wUCoh57H-XR0o+vzT2Fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2014 06:51 PM, Linus Torvalds wrote:
> On Sun, Mar 9, 2014 at 5:15 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>> The same collection of fixes except the broken NMI patch dropped.  I
>> will send a fixed version of that plus Suresh' FPU fix in a few days,
>> to get them some testing, plus I will be on a trip (part of why I got
>> unduly rushed this past Friday.  Sorry again for that.)
> 
> I already pulled the broken one, and had actually pushed it out in
> that broken format, which was so upsetting. Normally I tend to delay
> pushing things out until I've done my compile tests, but I had
> stupidly thought I didn't need to that time.
> 

So I see.  Thanks and sorry again.

	-hpa


