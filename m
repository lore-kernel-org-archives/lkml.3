Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaGDI54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:57:56 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:43125 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaGDI5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:57:53 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCHES 0/7] Add support for showing headers in the hist browser.
References: <1404423780-24026-1-git-send-email-acme@kernel.org>
	<20140703214811.GC11267@kernel.org>
Date: Fri, 04 Jul 2014 17:53:02 +0900
In-Reply-To: <20140703214811.GC11267@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Thu, 3 Jul 2014 18:48:11 -0300")
Message-ID: <878uo94ia9.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Thu, 3 Jul 2014 18:48:11 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jul 03, 2014 at 06:42:53PM -0300, Arnaldo Carvalho de Melo escreveu:
>> 	Please let me know if you are ok with it and if I can have your
>> Acked-by and perhaps Tested-by tags for the code I wrote.
>> 
>> 	Namhyung, since you reviewed the previous patchkit, I'd like to know
>> if I can keep the acked-by and perhaps a tested-by too. This should address the
>> problems that Jiri pointed out in our private conversation.
>
> Forgot to mention, it is available in this branch:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
>   tmp.perf/ui/show_headers

Thanks, you can keep my acks with fixing 7/7 changelog typo
(s/true/false/).

I think it might even go to the perf/urgent as the cumulative children
patchset added a new children column which might confuse old users (like
you ;-) ).  But I also think it needs to fix column/header alignment
first, hmm...

Thanks,
Namhyung
