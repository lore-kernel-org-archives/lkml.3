Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab3JJBGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 21:06:14 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44817 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab3JJBGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 21:06:12 -0400
X-AuditID: 9c930179-b7c78ae000003065-35-5255fd817007
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/8] perf callchain: Convert children list to rbtree
References: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
	<1380185890-25758-2-git-send-email-namhyung@kernel.org>
	<20131002101826.GC7941@localhost.localdomain>
	<87siwcldsr.fsf@sejong.aot.lge.com>
	<20131008192242.GA8392@localhost.localdomain>
Date: Thu, 10 Oct 2013 10:06:08 +0900
In-Reply-To: <20131008192242.GA8392@localhost.localdomain> (Frederic
	Weisbecker's message of "Tue, 8 Oct 2013 21:22:45 +0200")
Message-ID: <87zjqij5of.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Tue, 8 Oct 2013 21:22:45 +0200, Frederic Weisbecker wrote:
> On Tue, Oct 08, 2013 at 11:03:16AM +0900, Namhyung Kim wrote:
>> On Wed, 2 Oct 2013 12:18:28 +0200, Frederic Weisbecker wrote:
>> > Have you tested this patchset when collapsing is not used?
>> > There are fair chances that this patchset does not only improve collapsing
>> > but also callchain insertion in general. So it's probably a win in any case. But
>> > still it would be nice to make sure that it's the case because we are getting
>> > rid of collapsing anyway.
>> >
>> > The test that could tell us about that is to run "perf report -s sym" and compare the
>> > time it takes to complete before and after this patch, because "-s sym" shouldn't
>> > involve collapses.
>> >
>> > Sorting by anything that is not comm should do the trick in fact.
>> 
>> Yes, I have similar result when collapsing is not used.  Actually when I
>> ran "perf report -s sym", the performance improves higher since it'd
>> insert more callchains in a hist entry.
>
> Great! I'll have a closer look and review on the callchain patches then. Please
> resend these along the comm batch.

I'll do it later today or tomorrow.

Thanks,
Namhyung
