Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3JVJMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 05:12:54 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56396 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3JVJMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 05:12:53 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/8] perf ui/progress: Add new helper functions for progress bar
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
	<1381468543-25334-3-git-send-email-namhyung@kernel.org>
	<20131021181324.GA3288@ghostprotocols.net>
Date: Tue, 22 Oct 2013 18:12:40 +0000
In-Reply-To: <20131021181324.GA3288@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Mon, 21 Oct 2013 15:13:24 -0300")
Message-ID: <87wql5jht3.fsf@danjae.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, 21 Oct 2013 15:13:24 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Oct 11, 2013 at 02:15:37PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Introduce ui_progress_setup() and ui_progress__advance() to separate
>> out from the session logic.  It'll be used by other places in the
>> upcoming patch.
>
> Renaming this from 'perf_progress' to 'ui_progress', as the existing
> method names implies, and also because this is not perf specific at all
> :-)

I'm not sure I understood you correctly.  You're talking about the
struct perf_progree right?  We already have struct ui_progress for
saving UI-specific function pointers.  Am I missing something?

Thanks,
Namhyung
