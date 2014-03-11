Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaCKKEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:04:14 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:41647 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaCKKEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:04:12 -0400
Date: Tue, 11 Mar 2014 11:04:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Albert Strasheim <albert@cloudflare.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, stable@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20140311100406.GA32500@gmail.com>
References: <1394486108-5974-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394486108-5974-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> 
> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit af76815a31adc75dd9526230affdd678e65ac59f:
> 
>   Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2014-03-01 10:13:25 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to fdf57dd052d5cbd415533ae98f4d423286a85220:
> 
>   perf machine: Use map as success in ip__resolve_ams (2014-03-10 11:19:36 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> . Fix build of 'trace' in some systems due to using some architecture-specific
>   signal numbers (Ben Hutchings)
> 
> . Stop resolving when finding a map in in ip__resolve_ams, this way at least
>   the DSO will be resolved when a symbol isn't (Don Zickus)
> 
> . Fix crash in elf_section_by_name when not checking if some section string index
>   is valid (Jiri Olsa)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Ben Hutchings (1):
>       perf trace: Decode architecture-specific signal numbers
> 
> Don Zickus (1):
>       perf machine: Use map as success in ip__resolve_ams
> 
> Jiri Olsa (1):
>       perf symbols: Fix crash in elf_section_by_name
> 
>  tools/perf/builtin-trace.c   | 10 +++++++++-
>  tools/perf/util/machine.c    |  2 +-
>  tools/perf/util/symbol-elf.c |  6 +++---
>  3 files changed, 13 insertions(+), 5 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
