Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab3HMC2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 22:28:48 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59711 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab3HMC2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 22:28:47 -0400
X-AuditID: 9c930197-b7b44ae00000347f-61-520999dd326c
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/3] perf: add a dummy software event to keep tracking
References: <1375882231-18339-1-git-send-email-adrian.hunter@intel.com>
Date: Tue, 13 Aug 2013 11:28:45 +0900
In-Reply-To: <1375882231-18339-1-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Wed, 7 Aug 2013 16:30:28 +0300")
Message-ID: <87mwomwcgy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Wed,  7 Aug 2013 16:30:28 +0300, Adrian Hunter wrote:
> Hi
>
> This is an alternative to the 'keep tracking' flag patch
> which is here:
>
> 	http://marc.info/?l=linux-kernel&m=137242545521246&w=2
>
> perf tools is updated and a test added to demonstrate the
> new event.

It looks like a perfect fit for tracking fork/mmap events on
perf-ftrace. :)

Thanks,
Namhyung
