Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3LCCeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:34:11 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58700 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3LCCeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:34:08 -0500
X-AuditID: 9c930197-b7c3dae000002c11-b7-529d431e979c
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC 0/3] perf tools: Show time info (v1)
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
	<20131202170448.GF17656@two.firstfloor.org>
Date: Tue, 03 Dec 2013 11:34:06 +0900
In-Reply-To: <20131202170448.GF17656@two.firstfloor.org> (Andi Kleen's message
	of "Mon, 2 Dec 2013 18:04:48 +0100")
Message-ID: <87bo0yoe75.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Mon, 2 Dec 2013 18:04:48 +0100, Andi Kleen wrote:
> On Mon, Dec 02, 2013 at 03:53:16PM +0900, Namhyung Kim wrote:
>> Hi,
>> 
>> Sometimes users might want to see time information along with the
>> performance result but the perf cannot provide it currently.
>> 
>> In this patchset, I added such feature using sample->time.  When the
>> perf processes sample events, it calculate time info and update last
>> timestamp.  It keeps the last timestamp for each evsel (and for each
>> cpu if it's a per-cpu session).
>
> Does the sorting on arbitary fields work now?
>
> I believe to make use of this you totally want to sort on it too,
> but traditionally perf report could only sort on a single field.
>
> Without sorting adding more and more fields is just confusing. 

Yeah, that's the plan that I also have.  As Ingo requested, we'll have
more flexible field and sort-key selection options.  I'll work on that
as soon as the on-going works find their way to inclusion.

Thanks,
Namhyung
