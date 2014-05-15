Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaEONzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:55:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbaEONzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:55:23 -0400
Date: Thu, 15 May 2014 15:54:57 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCHSET 00/20] perf report: Add -F option for specifying
 output fields (v5)
Message-ID: <20140515135457.GI25858@krava.brq.redhat.com>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 03:28:33PM +0900, Namhyung Kim wrote:

SNIP

>   $ perf report -F sym,sample -s overhead
>   ...
>   #                     Symbol       Samples  Overhead
>   # ..........................  ............  ........
>   #
>     [.] strcmp                            11    13.75%
>     [.] a                                  8    10.00%
>     [.] b                                  8    10.00%
>     [.] c                                  8    10.00%
>     [.] main                               7     8.75%
>     [.] _setjmp                            6     7.50%
>     [.] _init                              5     6.25%
>     [.] frame_dummy                        5     6.25%
>     [.] __libc_csu_init                    4     5.00%
>     [.] _dl_name_match_p                   4     5.00%
>     [.] __new_exitfn                       3     3.75%
>     [.] __cxa_atexit                       2     2.50%
>     [.] _dl_check_map_versions             1     1.25%
>     [.] _dl_setup_hash                     1     1.25%
>     [.] _dl_sysdep_start                   1     1.25%
>     [.] brk                                1     1.25%
>     [.] calloc@plt                         1     1.25%
>     [.] dl_main                            1     1.25%
>     [.] match_symbol                       1     1.25%
>     [.] sbrk                               1     1.25%
>     [.] strlen                             1     1.25%
> 
> 
>  * changes in v5:
>   - add a testcase for hist output sorting

cool, had just few questions.. otherwise it seems ok to me

thanks,
jirka
