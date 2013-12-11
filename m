Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab3LKBVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:21:16 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:53098 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab3LKBVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:21:11 -0500
X-AuditID: 9c93017e-b7bb9ae000000ec8-aa-52a7be03f2e2
From: Namhyung Kim <namhyung@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] tools/: Convert to new topic libraries
References: <1386605664-24041-1-git-send-email-bp@alien8.de>
	<1386605664-24041-2-git-send-email-bp@alien8.de>
	<87zjo9jxs5.fsf@sejong.aot.lge.com> <20131210112758.GA31437@pd.tnic>
Date: Wed, 11 Dec 2013 10:21:07 +0900
In-Reply-To: <20131210112758.GA31437@pd.tnic> (Borislav Petkov's message of
	"Tue, 10 Dec 2013 12:27:59 +0100")
Message-ID: <87iouwi3ng.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Tue, 10 Dec 2013 12:27:59 +0100, Borislav Petkov wrote:
> On Tue, Dec 10, 2013 at 10:32:42AM +0900, Namhyung Kim wrote:
>> I'm sorry to raise a naming issue again. But why the lib has 'k' and
>> the directory doesn't? Isn't it more natural to prepend 'k' to 'api'
>> as the name "api" looks too general?
>>
>>   - libkapifs.{a,so} /kapi/fs/fs.c
>>
>> (Please ignore if it's already discussed..)
>
> Hmm, no, it hasn't been discussed but I assumed tools/lib/api/ being in
> the *kernel* repository implicitly says which api functionality we're
> collecting there. One of the main reasons to have tools/ in the kernel
> AFAIU is to have those tools which are using its API close. Therefore,
> tools/lib/api/ should be unambiguous.
>
> libkapifs.a (and the .so version even more, for that matter, and if we
> decide to do it one day) would probably need more distinction and the
> "k" in "kapi" there makes more sense.
>
> This is at least how I see it from here.

Yeah I assumed you guys plan to export it to the wild. :)

I'm OK with tools/lib/api if it lives and used only in the kernel tree.

Thanks,
Namhyung
