Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaDYHxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:53:51 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:46987 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaDYHxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:53:50 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 0/9] perf tools: Fixup for the --percentage change
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
	<20140422095557.GB10813@gmail.com> <87k3agsla6.fsf@sejong.aot.lge.com>
	<20140423060938.GA20455@gmail.com>
Date: Fri, 25 Apr 2014 16:53:47 +0900
In-Reply-To: <20140423060938.GA20455@gmail.com> (Ingo Molnar's message of
	"Wed, 23 Apr 2014 08:09:38 +0200")
Message-ID: <87ha5hrgj8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Wed, 23 Apr 2014 08:09:38 +0200, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
>> Well, I'm okay to add the extra decimal, but it seems that it only makes
>> sense when the unit is 'K'..
>> 
>> And I think it might be worth adding filtered sample count as well if
>> filtering is enabled something like:
>> 
>>   Captured 13.2K/42.1K 'cycles' event samples
>
> Yeah. Maybe make it:
>
>     Filtered 13.2K out of 42.1K 'cycles' event samples

Looks better to me.

Thanks,
Namhyung
