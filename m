Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaCKH5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:57:15 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:51672 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbaCKH5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:57:12 -0400
X-AuditID: 9c93017d-b7c89ae000006ae1-c9-531ec1d6ccf1
From: Namhyung Kim <namhyung@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/9] perf tools: Update on filtered entries' percentage output (v7)
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
	<20140310220819.GL22728@two.firstfloor.org>
	<1394506703.3867.22.camel@buesod1.americas.hpqcorp.net>
Date: Tue, 11 Mar 2014 16:57:10 +0900
In-Reply-To: <1394506703.3867.22.camel@buesod1.americas.hpqcorp.net>
	(Davidlohr Bueso's message of "Mon, 10 Mar 2014 19:58:23 -0700")
Message-ID: <8738ipuq09.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

On Mon, 10 Mar 2014 19:58:23 -0700, Davidlohr Bueso wrote:
> On Mon, 2014-03-10 at 23:08 +0100, Andi Kleen wrote:
>> On Mon, Mar 10, 2014 at 04:43:51PM +0900, Namhyung Kim wrote:
>> > Hello,
>> > 
>> > I added --percentage option to perf report to control display of
>> > percentage of filtered entries.
>> > 
>> >  usage: perf report [<options>]
>> > 
>> >         --percentage <relative|absolute>
>> >                           how to display percentage of filtered entries
>> 
>> Just as a high level comment. We have a lot of different display 
>> options now. It's hard to figure out what they all do for non experts.
>> 
>> It may be useful to define a number of high level layout combinations
>> that are useful for different situations and have a single
>> option to select everything together.
>
> Yes please, absolutely. The wiki page could use some love as well. I
> imagine the manpage is updated but it's also nice to have some examples
> of the newer features in perf.wiki.kernel.org.

Right, will try - as a side note, being a non-native speaker, I feel
more difficult to write a note/comment rather than a code. :)

Thanks,
Namhyung
