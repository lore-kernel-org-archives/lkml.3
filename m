Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab3GQT7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:59:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab3GQT7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:59:30 -0400
Date: Wed, 17 Jul 2013 16:59:05 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 06/23] perf doc: Add perf data file documentation
Message-ID: <20130717195905.GC5127@infradead.org>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
 <1374083403-14591-7-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374083403-14591-7-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 17, 2013 at 07:49:46PM +0200, Jiri Olsa escreveu:
> Adding perf data file documentation.
> 
> TODO: Finish the FEATURES section
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>

    ASCIIDOC /tmp/build/perf/perf-evlist.xml
asciidoc: ERROR: perf-data-file-v2.txt: line 5: name section expected
asciidoc: FAILED: perf-data-file-v2.txt: line 5: section title expected
make[2]: *** [/tmp/build/perf/perf-data-file-v2.xml] Error 1
make[2]: *** Waiting for unfinished jobs....
make[2]: Leaving directory `/home/git/linux/tools/perf/Documentation'
make[1]: *** [try-install-man] Error 2
make[1]: Leaving directory `/home/git/linux/tools/perf/Documentation'
make: *** [try-install-man] Error 2
make: Leaving directory `/home/git/linux/tools/perf'
[acme@zoo linux]$ 

