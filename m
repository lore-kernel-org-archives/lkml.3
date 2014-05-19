Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaESF6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:58:23 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:45632 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaESF6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:58:22 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
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
	<20140515125132.GC25858@krava.brq.redhat.com>
	<8761l6kzga.fsf@sejong.aot.lge.com>
Date: Mon, 19 May 2014 14:58:14 +0900
In-Reply-To: <8761l6kzga.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Fri, 16 May 2014 15:30:29 +0900")
Message-ID: <87oayujond.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, 16 May 2014 15:30:29 +0900, Namhyung Kim wrote:
> On Thu, 15 May 2014 14:51:32 +0200, Jiri Olsa wrote:
>> On Mon, May 12, 2014 at 03:28:41PM +0900, Namhyung Kim wrote:
>>
>> SNIP
>>
>>> +static struct hpp_dimension hpp_sort_dimensions[] = {
>>> +	DIM(PERF_HPP__OVERHEAD, "overhead"),
>>> +	DIM(PERF_HPP__OVERHEAD_SYS, "overhead_sys"),
>>> +	DIM(PERF_HPP__OVERHEAD_US, "overhead_us"),
>>> +	DIM(PERF_HPP__OVERHEAD_GUEST_SYS, "overhead_guest_sys"),
>>> +	DIM(PERF_HPP__OVERHEAD_GUEST_US, "overhead_guest_us"),
>>> +	DIM(PERF_HPP__SAMPLES, "sample"),
>>> +	DIM(PERF_HPP__PERIOD, "period"),
>>> +};
>>
>> just a nit.. overhead_guest_us|sys misplace are not properly aligned

Ah.. this is a pre-existing bug and I plan to fix it (along with other
related things) in a different series soon.  So let's skip this for
now. ;-p

Thanks,
Namhyung
