Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaCKHpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:45:11 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:45897 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaCKHpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:45:09 -0400
X-AuditID: 9c93017d-b7c89ae000006ae1-f8-531ebf03f664
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/9] perf tools: Update on filtered entries' percentage output (v7)
In-Reply-To: <20140310220819.GL22728@two.firstfloor.org> (Andi Kleen's message
	of "Mon, 10 Mar 2014 23:08:19 +0100")
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
	<20140310220819.GL22728@two.firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Tue, 11 Mar 2014 16:45:07 +0900
Message-ID: <877g81uqkc.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Mon, 10 Mar 2014 23:08:19 +0100, Andi Kleen wrote:
> On Mon, Mar 10, 2014 at 04:43:51PM +0900, Namhyung Kim wrote:
>> Hello,
>> 
>> I added --percentage option to perf report to control display of
>> percentage of filtered entries.
>> 
>>  usage: perf report [<options>]
>> 
>>         --percentage <relative|absolute>
>>                           how to display percentage of filtered entries
>
> Just as a high level comment. We have a lot of different display 
> options now. It's hard to figure out what they all do for non experts.

Absolutely agreed.

>
> It may be useful to define a number of high level layout combinations
> that are useful for different situations and have a single
> option to select everything together.
>
> Perhaps --layout FOO and FOO a number of predefined layouts.

Yeah, that will be useful for me too :)

Btw, do you have concrete examples of the situations?  I'll also think
about it too, but it'd be wonderful if you guys share how you use the
perf tools for various purpose in detail.

Thanks,
Namhyung
