Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbaJXNOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:14:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:17384 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbaJXNOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:14:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,780,1406617200"; 
   d="scan'208";a="610602943"
Message-ID: <544A505C.5030203@intel.com>
Date: Fri, 24 Oct 2014 16:13:00 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/16] perf tools: Add facility to export data in database-friendly
 way
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com> <1414061124-26830-6-git-send-email-adrian.hunter@intel.com> <87lho6c8ec.fsf@sejong.aot.lge.com> <544A099C.50104@intel.com> <544A2E5F.80508@intel.com> <CAM9d7ci6bv_JnK8DkqqTEttPkEp1mtMPN07XjqX=K4ADOUC6SA@mail.gmail.com>
In-Reply-To: <CAM9d7ci6bv_JnK8DkqqTEttPkEp1mtMPN07XjqX=K4ADOUC6SA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/10/14 15:26, Namhyung Kim wrote:
> Hi Adrian,
> 
> On Fri, Oct 24, 2014 at 7:47 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
>> On 24/10/14 11:11, Adrian Hunter wrote:
>>> On 24/10/14 09:02, Namhyung Kim wrote:
>>>> Can we do it somewhere in a script not in the core code?  I don't feel
>>>> comfortable to add those bits into the core code.  What if we export
>>>
>>> Please explain what you mean by "comfortable".
>>
>> Or rather: What about it is wrong for core code?
> 
> Well, there's nothing "wrong" about it. :)
> 
> But I think if some code is used only by a specific bits, it'd be
> better hiding it from the rest as much as possible.

It is pretty self-contained in db-export.[ch] and the scripting
engines.

