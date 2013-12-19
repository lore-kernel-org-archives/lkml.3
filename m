Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab3LSHUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:20:50 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47575 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3LSHUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:20:49 -0500
X-AuditID: 9c93017d-b7c5eae000004296-c1-52b29e4ecdfe
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [RFC/PATCHSET 00/18] perf report: Add support to accumulate hist periods (v3)
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
	<20131218094622.GA19240@gmail.com> <1387377469.1717.12.camel@leonhard>
	<20131218174715.GF4819@ghostprotocols.net>
Date: Thu, 19 Dec 2013 16:20:46 +0900
In-Reply-To: <20131218174715.GF4819@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 18 Dec 2013 14:47:15 -0300")
Message-ID: <87haa5fgs1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013 14:47:15 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Dec 18, 2013 at 11:37:49PM +0900, Namhyung Kim escreveu:
>> 2013-12-18 (수), 10:46 +0100, Ingo Molnar:
>> > * Namhyung Kim <namhyung@kernel.org> wrote:
>
>> > > I changed the option as a separate --cumulate and added a new
>> > > "Total" column (and renamed the default "Overhead" column into
>> > > "Self").  The output will be sorted by total (cumulative) overhead
>> > > for now.  The reason I changed to the --cumulate is that I still
>> > > think it's much different from other --callchain options and I
>> > > plan to add support for showing (remaining) callchains to
>> > > cumulative entries too.  The --callchain option will take care of
>> > > it even with --cumulate option.
>
>> > So I still think this is a fantastic feature, and while this variant 
>> > of the user interface is an improvement over the previous version, we 
>> > are not there yet ;-)
>> 
>> Right.  But I want to finish the core part of this patchset first.  And
>> then I will work on the UI part since it'll be a quite large work by
>> itself, I guess.
>
> I got the first few ones, that are not really related to this, to reduce
> the patchkit size, will go thru the others next.

Right.  I missed to mention that they're independent cleanups, thanks.

>  
>> > So the natural way to get this would something like:
>> > 
>> > 	perf report --total
>> > 
>> > Or, if '--total' does not feel good, maybe we should change 'Total' to 
>> > 'Siblings' or 'Children', and propagate that naming through the UI:
>> 
>> Childrend looks better to me.
>
> --children, ack

Okay.

Thanks,
Namhyung
