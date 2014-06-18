Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbaFRAgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:36:16 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48821 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbaFRAgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:36:15 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 9/9] perf, tools: Add a --quiet flag to perf list
References: <1402700580-26939-1-git-send-email-andi@firstfloor.org>
	<1402700580-26939-10-git-send-email-andi@firstfloor.org>
	<1402838261.1684.39.camel@leonhard>
	<20140615161138.GH5714@two.firstfloor.org>
Date: Wed, 18 Jun 2014 09:36:12 +0900
In-Reply-To: <20140615161138.GH5714@two.firstfloor.org> (Andi Kleen's message
	of "Sun, 15 Jun 2014 18:11:38 +0200")
Message-ID: <87k38f835v.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Sun, 15 Jun 2014 18:11:38 +0200, Andi Kleen wrote:
> On Sun, Jun 15, 2014 at 10:17:41PM +0900, Namhyung Kim wrote:
>> > It's still default to print descriptions as that is the more useful
>> > default for most users.  Requested by Namhyung Kim.
>> 
>> Did I request the --quiet thing?  It seems like there's a
>> miscommunication.. :-/
>
> Well it was done based on your feedback, and gets the closest
> to your original request as possible.
>
>> Btw, it'd better if it can support event glob on the pmu events (or
>> simply all events) too as this will increase the number of events
>> significantly.  But this can be a further work.
>
> That already works.

Oh, didn't notice that.  Nice work! :)

Thanks,
Namhyung


>
> % perf list icache*
> List of pre-defined events (to be used in -e):
>   icache.ifetch_stall                                [Cycles where a code-fetch
>                                                       stalled due to L1
>                                                       instruction-cache miss
>                                                       or an iTLB miss]
>   icache.misses                                      [Number of Instruction
>                                                       Cache, Streaming Buffer
>                                                       and Victim Cache
>                                                       Misses. Includes
>                                                       Uncacheable accesses]
> %
>
> -Andi
