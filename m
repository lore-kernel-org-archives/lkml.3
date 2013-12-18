Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3LREDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 23:03:12 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48457 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3LREDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 23:03:10 -0500
X-AuditID: 9c930179-b7d01ae000005b41-a9-52b11e7c4f72
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 00/71] perf: Add support for Intel Processor Trace
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
	<20131211130448.GA2480@gmail.com>
	<87r49jttqr.fsf@ashishki-desk.ger.corp.intel.com>
	<20131211134724.GC3101@gmail.com>
	<87bo0ht5nj.fsf@ashishki-desk.ger.corp.intel.com>
	<20131216143751.GA7959@gmail.com>
	<20131216151852.GW22695@tassilo.jf.intel.com>
	<20131216153008.GA26686@localhost.localdomain>
	<20131216154527.GX22695@tassilo.jf.intel.com>
Date: Wed, 18 Dec 2013 13:03:07 +0900
In-Reply-To: <20131216154527.GX22695@tassilo.jf.intel.com> (Andi Kleen's
	message of "Mon, 16 Dec 2013 07:45:27 -0800")
Message-ID: <87y53ig610.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Mon, 16 Dec 2013 07:45:27 -0800, Andi Kleen wrote:
>> My hope has always been that we can make a userspace function graph tracer
>> out of its dumps. And I think we can, I'm pretty sure that would be a useful tool.
>
> I wrote one, based on the __fentry__, like the kernel:
> http://github.com/andikleen/ftracer

Oh, I'm writing a similar one too.  I'll take a look at yours.

Thanks,
Namhyung
