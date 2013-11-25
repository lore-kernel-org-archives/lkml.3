Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab3KYIEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:04:50 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:46854 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab3KYIEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:04:49 -0500
X-AuditID: 9c93017e-b7ba2ae00000088c-67-5293049fe118
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tracing: Introduce "pseudo registers" for FETCH_MTD_reg
References: <20131123201543.GA22148@redhat.com>
	<20131123201605.GB22148@redhat.com> <5291ABA5.7030505@hitachi.com>
Date: Mon, 25 Nov 2013 17:04:47 +0900
In-Reply-To: <5291ABA5.7030505@hitachi.com> (Masami Hiramatsu's message of
	"Sun, 24 Nov 2013 16:32:53 +0900")
Message-ID: <877gbwsy8w.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Nov 2013 16:32:53 +0900, Masami Hiramatsu wrote:
> (2013/11/24 5:16), Oleg Nesterov wrote:
>> The probe can dump the registers or memory, but it is not possible
>> to dump, say, current->pid. This patch adds the pseudo regs table,
>> currently it has only two methods to get current/smp_processor_id
>> but it can be trivially extended.
>
> Good catch! :)
>
>> This syntax is %%pseudo-reg-name, I agree in advance with any other
>> naming.
>
> For this kind of use, kprobe-tracer already provides '$' prefix :)
> e.g. $stack, $retval etc. Please see parse_probe_vars in trace_probe.c.
>
> So, $current and $cpu is better for me.

Agreed.

Thanks,
Namhyung
