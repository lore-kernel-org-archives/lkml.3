Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaAFHpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:45:18 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:64951 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaAFHpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:45:17 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-74-52ca5f0a54de
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/21] perf tools: Introduce struct add_entry_iter
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
	<1387873347-28838-2-git-send-email-namhyung@kernel.org>
	<20140105145542.GA7734@krava.brq.redhat.com>
Date: Mon, 06 Jan 2014 16:45:14 +0900
In-Reply-To: <20140105145542.GA7734@krava.brq.redhat.com> (Jiri Olsa's message
	of "Sun, 5 Jan 2014 15:55:42 +0100")
Message-ID: <87wqideeph.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jan 2014 15:55:42 +0100, Jiri Olsa wrote:
> On Tue, Dec 24, 2013 at 05:22:07PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> +static int
>> +iter_finish_branch_entry(struct add_entry_iter *iter,
>> +			 struct addr_location *al __maybe_unused)
>> +{
>> +	free(iter->priv);
>> +	iter->priv = NULL;
>
> Arnaldo just added zfree ;-)

Will change.

Thanks,
Namhyung
