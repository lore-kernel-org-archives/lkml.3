Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbbAFSGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:06:08 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:51059 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbbAFSFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:05:30 -0500
MIME-Version: 1.0
In-Reply-To: <54AA3C1E.10200@intel.com>
References: <1420232625-3628-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<54AA3C1E.10200@intel.com>
Date: Tue, 6 Jan 2015 19:05:29 +0100
Message-ID: <CAKXHbyP54J4ZaiMVGMvVUXh4ie0zsQhwc9TEbPEqE9x6W_RyxQ@mail.gmail.com>
Subject: Re: [PATCH] tools: perf: util: dso: Remove some unused functions
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-05 8:24 GMT+01:00 Adrian Hunter <adrian.hunter@intel.com>:
> On 02/01/15 23:03, Rickard Strandqvist wrote:
>> Removes some functions that are not used anywhere:
>> dso__data_size() dso__data_status_seen()
>>
>> This was partially found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>
> Please do not remove these. They are also preparation for Intel PT.
>


Hi

Ok, sorry!

But this  obvious, or would it not be good to add same comments?


Kind regards
Rickard Strandqvist
