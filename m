Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3LJL2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:28:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60613 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab3LJL2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:28:05 -0500
Date: Tue, 10 Dec 2013 12:27:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Namhyung Kim <namhyung@kernel.org>
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
Message-ID: <20131210112758.GA31437@pd.tnic>
References: <1386605664-24041-1-git-send-email-bp@alien8.de>
 <1386605664-24041-2-git-send-email-bp@alien8.de>
 <87zjo9jxs5.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87zjo9jxs5.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 10:32:42AM +0900, Namhyung Kim wrote:
> I'm sorry to raise a naming issue again. But why the lib has 'k' and
> the directory doesn't? Isn't it more natural to prepend 'k' to 'api'
> as the name "api" looks too general?
>
>   - libkapifs.{a,so} /kapi/fs/fs.c
>
> (Please ignore if it's already discussed..)

Hmm, no, it hasn't been discussed but I assumed tools/lib/api/ being in
the *kernel* repository implicitly says which api functionality we're
collecting there. One of the main reasons to have tools/ in the kernel
AFAIU is to have those tools which are using its API close. Therefore,
tools/lib/api/ should be unambiguous.

libkapifs.a (and the .so version even more, for that matter, and if we
decide to do it one day) would probably need more distinction and the
"k" in "kapi" there makes more sense.

This is at least how I see it from here.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
