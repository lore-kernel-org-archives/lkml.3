Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaHFBJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:09:04 -0400
Received: from ozlabs.org ([103.22.144.67]:36773 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbaHFBJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:09:03 -0400
Message-ID: <1407287340.32238.1.camel@concordia>
Subject: Re: [PATCH 09/13] perf tools: Add perf download to download event
 files
From: Michael Ellerman <mpe@ellerman.id.au>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Wed, 06 Aug 2014 11:09:00 +1000
In-Reply-To: <20140717104704.GB9571@gmail.com>
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
	 <1405540969-18975-10-git-send-email-jolsa@kernel.org>
	 <20140717104704.GB9571@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-17 at 12:47 +0200, Ingo Molnar wrote:
> this bit needs more discussion:
> 
> * Jiri Olsa <jolsa@kernel.org> wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Add a downloader to automatically download the right
> > files from a download site.
> 
> 'A download site' is way too vague and detached from the perf project.
> 
> > +	echo "Downloading models file"
> > +	URLBASE=${URLBASE:-https://download.01.org/perfmon}
> 
> We want these description files to be in the perf source code, 
> somewhere in tools/perf/live-config/arch/x86/ or so, and installed 
> during 'make install' - i.e. part of perf project and installed in 
> ~/.debug or ~/.perf or so.

Surely the shipped versions should go in /usr/share/perf or something like
that? Rather than a particular users home directory?

> Those files could be refreshed via 'perf download' and could be 
> accessible via kernel.org as well, 'perf download' should pick up 
> these files from Linus's latest git repository (via the HTTP 
> namespace).

This version would go in ~/.perf or similar.

cheers


