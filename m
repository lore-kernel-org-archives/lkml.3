Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbbAIVJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:09:20 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38978 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbbAIVJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:09:18 -0500
From: Julian Brost <julian@0x4a42.net>
X-Google-Original-From: Julian Brost <linux-kernel@0x4a42.net>
Message-ID: <54B041E5.7090005@0x4a42.net>
Date: Fri, 09 Jan 2015 22:02:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: x86@kernel.org
CC: Fabian Hofmann <fabian.hofmann@fau.de>, linux-kernel@i4.cs.fau.de,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] perf/x86/intel/uncore: Fix multiple coding style
 issues
References: <1418751050-11725-1-git-send-email-linux-kernel@0x4a42.net> <1418921500-5630-1-git-send-email-linux-kernel@0x4a42.net>
In-Reply-To: <1418921500-5630-1-git-send-email-linux-kernel@0x4a42.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.12.2014 17:51, Julian Brost wrote:
> The following patch series fixes multiple coding style issues. Most of them
> were found by checkpatch.
> 
> v2: This is the version that's actually supposed to be sent out.
> 
> Julian Brost (5):
>   perf/x86/intel/uncore: checkpatch: Replace deprecated macro.
>   perf/x86/intel/uncore: checkpatch: Replace kzalloc with kcalloc
>   perf/x86/intel/uncore: coding style: Fix alignment in macros
>   perf/x86/intel/uncore: checkpatch: Remove unnecessary line
>     continuation
>   perf/x86/intel/uncore: checkpatch: Add newlines after declarations
> 
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c      |  6 +++-
>  .../x86/kernel/cpu/perf_event_intel_uncore_nhmex.c |  1 +
>  .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 39 +++++++++++++---------
>  3 files changed, 30 insertions(+), 16 deletions(-)
> 

Do you have any feedback on these patches?

Thanks,
Julian
