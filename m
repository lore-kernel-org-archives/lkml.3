Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaJXFKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 01:10:48 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55191 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaJXFKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 01:10:42 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/16] perf tools: Add id index
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
	<1414061124-26830-2-git-send-email-adrian.hunter@intel.com>
	<20141023210817.GN14687@kernel.org>
Date: Fri, 24 Oct 2014 14:10:40 +0900
In-Reply-To: <20141023210817.GN14687@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Thu, 23 Oct 2014 18:08:17 -0300")
Message-ID: <8738aedpdb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014 18:08:17 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Oct 23, 2014 at 01:45:09PM +0300, Adrian Hunter escreveu:
>> Add an index of the event identifiers.
>> 
>> This is needed to queue Instruction
>> Trace samples according to the mmap
>> buffer from which they were recorded.
>
> This gets difficult to review, I end up having to look at all the
> patches together to figure out the use cases, to see if this here makes
> sense...
>
> Can you try to explain like to a seven year old?
>
> Sigh.
>
> 'id' is somethig super vague, what does this identifies? I want to make
> progress processing these patches, but with so short explanations like
> the above one, it gets difficult.

I also often get confused when I saw an id and/or idx. ;-)

Thanks,
Namhyung
