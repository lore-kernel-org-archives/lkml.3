Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbaDQIWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:22:01 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50781 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbaDQIV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:21:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/2] perf record: Propagate exit status of a command line workload
References: <CABPqkBQeAqRUW8LLMsHhHBR8gJcE4VPZa++ji8i=RKUCd2jSvQ@mail.gmail.com>
	<1397608244-15496-1-git-send-email-namhyung@kernel.org>
	<20140416133432.GA7040@krava.brq.redhat.com>
Date: Thu, 17 Apr 2014 17:21:53 +0900
In-Reply-To: <20140416133432.GA7040@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 16 Apr 2014 15:34:32 +0200")
Message-ID: <87ob00s6vy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Wed, 16 Apr 2014 15:34:32 +0200, Jiri Olsa wrote:
> On Wed, Apr 16, 2014 at 09:30:43AM +0900, Namhyung Kim wrote:
> I think that after creating the workload, all error paths
> need to release(wait) the child if there's any

Right.  I'll resend v2.

Thanks,
Namhyung
