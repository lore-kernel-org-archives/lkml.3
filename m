Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbbAGJ7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:59:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:37057 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbbAGJ7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:59:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,713,1413270000"; 
   d="scan'208";a="658034829"
Message-ID: <54AD030E.5000201@intel.com>
Date: Wed, 07 Jan 2015 11:57:34 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tools: perf: util: dso: Remove some unused functions
References: <1420232625-3628-1-git-send-email-rickard_strandqvist@spectrumdigital.se>	<54AA3C1E.10200@intel.com> <CAKXHbyP54J4ZaiMVGMvVUXh4ie0zsQhwc9TEbPEqE9x6W_RyxQ@mail.gmail.com>
In-Reply-To: <CAKXHbyP54J4ZaiMVGMvVUXh4ie0zsQhwc9TEbPEqE9x6W_RyxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/15 20:05, Rickard Strandqvist wrote:
> 2015-01-05 8:24 GMT+01:00 Adrian Hunter <adrian.hunter@intel.com>:
>> On 02/01/15 23:03, Rickard Strandqvist wrote:
>>> Removes some functions that are not used anywhere:
>>> dso__data_size() dso__data_status_seen()
>>>
>>> This was partially found by using a static code analysis program called cppcheck.
>>>
>>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>>> ---
>>
>> Please do not remove these. They are also preparation for Intel PT.
>>
> 
> 
> Hi
> 
> Ok, sorry!
> 
> But this  obvious, or would it not be good to add same comments?

The Intel PT preparation is a little unusual, and of course I am always
optimistic about getting the rest of the patches added. Adding a comment
only to remove it later seems a bit messy.

