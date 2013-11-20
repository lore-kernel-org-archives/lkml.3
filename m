Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab3KTHJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:09:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:29326 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab3KTHJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:09:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,735,1378882800"; 
   d="scan'208";a="430700374"
Message-ID: <528C61DE.5060001@intel.com>
Date: Wed, 20 Nov 2013 09:16:46 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/4] perf tools: Allow '--inherit' as the negation of
 '--no-inherit'
References: <1384768557-23331-1-git-send-email-adrian.hunter@intel.com> <1384768557-23331-3-git-send-email-adrian.hunter@intel.com> <528A8379.5030908@gmail.com> <528B1D7C.5010400@intel.com> <528B8FE8.4080301@gmail.com>
In-Reply-To: <528B8FE8.4080301@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/11/13 18:20, David Ahern wrote:
> On 11/19/13, 1:12 AM, Adrian Hunter wrote:
>> On 18/11/13 23:15, David Ahern wrote:
>>> Why not cleanup the options for the commands and move all of the no-xxxx to
>>> just xxxx? Anyone using no-xxxx would still just work by the existing code.
>>
>> Interesting idea but the short and long options are a combination, and short
>> options don't work the same way e.g. -i and --no-inherit go together.
>>
> 
> If inherit is on by default and -i / --inherit is the option then -i is a
> no-op and --no-inherit disables it. That's the same effect has having
> inherit on by default and an option to disable it called --no-inherit.

Well, if you are going to change the meaning of -i and deny the users a
short option to disable inheritance, then it is no longer a cleanup - it
is a functional change.

