Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaAFIdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:33:37 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55305 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaAFIdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:33:35 -0500
X-AuditID: 9c93017e-b7cd8ae000002ce9-0f-52ca6a5e59d7
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 12/21] perf tools: Apply percent-limit to cumulative percentage
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
	<1387873347-28838-13-git-send-email-namhyung@kernel.org>
	<20140105174033.GK10018@krava.brq.redhat.com>
Date: Mon, 06 Jan 2014 17:33:34 +0900
In-Reply-To: <20140105174033.GK10018@krava.brq.redhat.com> (Jiri Olsa's
	message of "Sun, 5 Jan 2014 18:40:33 +0100")
Message-ID: <87y52tcxwh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jan 2014 18:40:33 +0100, Jiri Olsa wrote:
> On Tue, Dec 24, 2013 at 05:22:18PM +0900, Namhyung Kim wrote:
>> +		if (symbol_conf.cumulate_callchain) {
>> +			percent = h->stat_acc->period * 100.0 /
>> +					hb->hists->stats.total_period;
>> +		} else {
>> +			percent = h->stat.period * 100.0 /
>> +					hb->hists->stats.total_period;
>> +		}
>
> seems like above code (7 lines) should go to function

Will do!

Thanks,
Namhyung
