Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaEPG3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 02:29:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:36071 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaEPG3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 02:29:47 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 08/20] perf tools: Allow hpp fields to be sort keys
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
	<1399876133-17963-9-git-send-email-namhyung@kernel.org>
	<20140515130728.GE25858@krava.brq.redhat.com>
Date: Fri, 16 May 2014 15:29:45 +0900
In-Reply-To: <20140515130728.GE25858@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 15 May 2014 15:07:28 +0200")
Message-ID: <87a9aikzhi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 15:07:28 +0200, Jiri Olsa wrote:
> On Mon, May 12, 2014 at 03:28:41PM +0900, Namhyung Kim wrote:
>> Add overhead{,_sys,_us,_guest_sys,_guest_us}, sample and period sort
>> keys so that they can be selected with --sort/-s option.
>> 
>>   $ perf report -s period,comm --stdio
>>   ...
>>   # Overhead        Period          Command
>>   # ........  ............  ...............
>>   #
>>       47.06%           152          swapper
>>       13.93%            45  qemu-system-arm
>>       12.38%            40         synergys
>>        3.72%            12          firefox
>>        2.48%             8            xchat
>> 
>> Acked-by: Ingo Molnar <mingo@kernel.org>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/ui/hist.c   |  9 +++++++--
>>  tools/perf/util/sort.c | 39 +++++++++++++++++++++++++++++++++++++++
>
> no documentation update.. Documentation/perf-report.txt

Will add.

>
> I wonder we want to update report's '-s' option help string.. it's already big ;-)

Right.  What about just listing basic/common keys and description like
"please refer the man page to the complete list." :)

Thanks,
Namhyung
