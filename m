Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab3LDV0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:26:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab3LDV0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:26:23 -0500
Date: Wed, 4 Dec 2013 22:25:56 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 28/28] perf tools: Add udis86 disassembler feature check
Message-ID: <20131204212555.GB3374@krava.zyxel.com>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
 <1386076182-14484-29-git-send-email-jolsa@redhat.com>
 <20131204185024.GC14788@ghostprotocols.net>
 <20131204185302.GD14788@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204185302.GD14788@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 03:53:02PM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

> Auto-detecting system features:
> ...                     backtrace: [ on  ]
> ...                         dwarf: [ on  ]
> ...                fortify-source: [ on  ]
> ...                         glibc: [ on  ]
> ...                          gtk2: [ on  ]
> ...                  gtk2-infobar: [ on  ]
> ...                      libaudit: [ on  ]
> ...                        libbfd: [ on  ]
> ...                        libelf: [ on  ]
> ...             libelf-getphdrnum: [ on  ]
> ...                   libelf-mmap: [ on  ]
> ...                       libnuma: [ on  ]
> ...                       libperl: [ on  ]
> ...                     libpython: [ on  ]
> ...             libpython-version: [ on  ]
> ...                      libslang: [ on  ]
> ...                     libunwind: [ on  ]
> ...                       on-exit: [ on  ]
> ...            stackprotector-all: [ on  ]
> ...                       timerfd: [ on  ]
> 
> config/Makefile:421: No udis86 support.
> 
> ---
> 
> Please try to fix it and resubmit. And yes, I don't have udis86-devel
> installed in this test system.

hum, I did not make it as the feature check with visible state '[ on ]',
but I guess check for packages should be on the list.. I'll repost

jirka
