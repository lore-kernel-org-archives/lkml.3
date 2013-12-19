Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3LSHRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:17:37 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43631 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3LSHRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:17:36 -0500
X-AuditID: 9c93016f-b7cc5ae000007121-dc-52b29d8e37c6
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/18] perf sort: Compare addresses if no symbol info
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
	<1387344086-12744-2-git-send-email-namhyung@kernel.org>
	<20131218153849.GF4146@krava.brq.redhat.com>
	<20131218173528.GA4819@ghostprotocols.net>
	<20131218173907.GB4819@ghostprotocols.net>
Date: Thu, 19 Dec 2013 16:17:34 +0900
In-Reply-To: <20131218173907.GB4819@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 18 Dec 2013 14:39:07 -0300")
Message-ID: <87lhzhfgxd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Wed, 18 Dec 2013 14:39:07 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Dec 18, 2013 at 02:35:28PM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Wed, Dec 18, 2013 at 04:38:49PM +0100, Jiri Olsa escreveu:
>> > > +static int64_t _sort__addr_cmp(u64 left_ip, u64 right_ip)
>> > > +{
>> > > +	return (int64_t)(right_ip - left_ip);
>> > > +}
>> > > +
>> > 
>> > what's the reason for the leading '_' in the name?
>> 
>> Yeah, I'm curious as well, the convention is to only use double _ in
>> front of functions when it does a little less than a function of the
>> same name without such prefix, like locking, etc.
>> 
>> - Arnaldo
>>  
>> > otherwise:
>> > 
>> > Acked-by: Jiri Olsa <jolsa@redhat.com>
>
> Yeah, I'll apply it, it just keeps whatever convention that is there
> already.

Exactly.  It's not a top-level sort/compare function, hence the leading
'_', I guess.


> I'll take a stab at fixing it all up after merging this
> --whatever-the-cumulate-option-becomes new code :-)

Thank you!
Namhyung
