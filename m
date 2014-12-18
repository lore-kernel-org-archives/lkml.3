Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaLRGYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:24:46 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46224 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaLRGYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:24:45 -0500
Date: Thu, 18 Dec 2014 07:24:40 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>, David Ahern <dsahern@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>,
        Mitchell Krome <mitchellkrome@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 00/18] perf/core improvements and fixes
Message-ID: <20141218062439.GA13965@gmail.com>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
 <20141217145035.GE11607@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217145035.GE11607@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Em Tue, Dec 16, 2014 at 01:57:02PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Hi Ingo,
> > 
> > 	Please consider pulling,
> > 
> > - Arnaldo
> > 
> > The following changes since commit 41e950c033b7df997d4b38653efe6554be9b96a7:
> > 
> >   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2014-12-12 09:09:52 +0100)
> > 
> > are available in the git repository at:
> > 
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> Ingo,
> 
> 	Please consider pulling the perf-core-for-mingo-2 signed tag
> instead, it is exactly the same content modulo removal of some
> whitespaces at the end of a few lines in tools/perf/Makefile.perf that
> Jiri found while reading those patches,

Pulled, thanks a lot!

	Ingo
