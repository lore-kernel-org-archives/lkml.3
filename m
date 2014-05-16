Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaEPGnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 02:43:40 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54975 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaEPGnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 02:43:39 -0400
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
Subject: Re: [PATCHSET 00/20] perf report: Add -F option for specifying output fields (v5)
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
	<20140515135457.GI25858@krava.brq.redhat.com>
Date: Fri, 16 May 2014 15:43:37 +0900
In-Reply-To: <20140515135457.GI25858@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 15 May 2014 15:54:57 +0200")
Message-ID: <87sioajk9y.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 15:54:57 +0200, Jiri Olsa wrote:
> On Mon, May 12, 2014 at 03:28:33PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>>   $ perf report -F sym,sample -s overhead
>>   ...
>>   #                     Symbol       Samples  Overhead
>>   # ..........................  ............  ........
>>   #
>>     [.] strcmp                            11    13.75%
>>     [.] a                                  8    10.00%
>>     [.] b                                  8    10.00%
>>     [.] c                                  8    10.00%
>>     [.] main                               7     8.75%
>>     [.] _setjmp                            6     7.50%
>>     [.] _init                              5     6.25%
>>     [.] frame_dummy                        5     6.25%
>>     [.] __libc_csu_init                    4     5.00%
>>     [.] _dl_name_match_p                   4     5.00%
>>     [.] __new_exitfn                       3     3.75%
>>     [.] __cxa_atexit                       2     2.50%
>>     [.] _dl_check_map_versions             1     1.25%
>>     [.] _dl_setup_hash                     1     1.25%
>>     [.] _dl_sysdep_start                   1     1.25%
>>     [.] brk                                1     1.25%
>>     [.] calloc@plt                         1     1.25%
>>     [.] dl_main                            1     1.25%
>>     [.] match_symbol                       1     1.25%
>>     [.] sbrk                               1     1.25%
>>     [.] strlen                             1     1.25%
>> 
>> 
>>  * changes in v5:
>>   - add a testcase for hist output sorting
>
> cool, had just few questions.. otherwise it seems ok to me

Thanks for your review.  I'll address your points and resend v6 next
week.

Thanks,
Namhyung
