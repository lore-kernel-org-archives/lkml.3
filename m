Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728Ab3DAUDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:03:45 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:24127 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759696Ab3DAUDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:03:43 -0400
Date: Mon, 1 Apr 2013 22:03:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 27/27] perf tools: Add kbuild support into
	Makefile.kbuild
Message-ID: <20130401200342.GD5744@merkur.ravnborg.org>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com> <1364843930-17974-28-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364843930-17974-28-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 09:18:50PM +0200, Jiri Olsa wrote:
> Adding kbuild support into Makefile.kbuild. The 'legacy'
> Makefile still stays untouched as it was.

When readign the Kbuild file I get confused.
the obj-y syntax is used for kernel built-in stuff,
and obj-m for modules.
I had expected either a perf specific syntax or something like the
syntax used for host programs.

	Sam
