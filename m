Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3KHHvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:51:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:35193 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab3KHHva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:51:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,658,1378882800"; 
   d="scan'208";a="424179887"
Message-ID: <527C9985.1080400@intel.com>
Date: Fri, 08 Nov 2013 09:57:57 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 06/11] perf record: Add an option to force per-cpu
 mmaps
References: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com> <1383313899-15987-7-git-send-email-adrian.hunter@intel.com> <20131104152942.GA4004@krava.brq.redhat.com> <5278AC36.1020702@intel.com> <20131105094220.GA1071@krava.brq.redhat.com> <5278EE0A.1080108@intel.com> <20131105133024.GE1071@krava.brq.redhat.com> <20131105142545.GD22912@ghostprotocols.net> <20131105173152.GB7329@ghostprotocols.net>
In-Reply-To: <20131105173152.GB7329@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/13 19:31, Arnaldo Carvalho de Melo wrote:
> PeterZ,
>
> 	Can I have your Acked-by for this one? I guess now the goal is
> achieved, no?

Ping

>
> - Arnaldo
>
> Em Tue, Nov 05, 2013 at 11:25:45AM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Tue, Nov 05, 2013 at 02:30:24PM +0100, Jiri Olsa escreveu:
>>> On Tue, Nov 05, 2013 at 03:09:30PM +0200, Adrian Hunter wrote:
>>>>> right, I haven't considered the hundreds CPU machine.. I just
>>>>> saw that it disables inherited events in my test ;-) maybe we
>>>>> could mentioned that somewhere, because it's not clear
>>>> How about this:
>>>>
>>>> From: Adrian Hunter <adrian.hunter@intel.com>
>>>>
>>>> By default, when tasks are specified (i.e. -p, -t
>>>> or -u options) per-thread mmaps are created.  Add
>>>> an option to override that and force per-cpu mmaps.
>>>>
>>>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>>> seems ok, thanks
>> Much better, but may I ask that the explanation in the man pages be
>> present in the changeset commit as well? So that by just looking at 'git
>> log' we can more readily get the whole picture, i.e. scalability versus
>> wanting to have inherit.
>>
>> - Arnaldo
>>  
>>> Acked-by: Jiri Olsa <jolsa@redhat.com>
>>>
>>> jirka
>

