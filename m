Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab3LWLyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 06:54:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab3LWLys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 06:54:48 -0500
Date: Mon, 23 Dec 2013 12:54:39 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf and Kconfig
Message-ID: <20131223115439.GA22852@krava.brq.redhat.com>
References: <CAMesUR48C3zBo_UJByjC9GSqK6V=W_-WDQrsAoGye2yNADD3NQ@mail.gmail.com>
 <52B4E815.8030304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B4E815.8030304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 06:00:05PM -0700, David Ahern wrote:
> [adding perf maintainers]
> 
> On 12/20/13, 5:39 PM, Alexis Berlemont wrote:
> >Hi,
> >
> >Here is a proposal of a small contribution which tries to fulfill the
> >task "Use Kconfig to allow selecting features and build minimal
> >version of perf,..." displayed on the todo page of the perf
> >wiki (https://perf.wiki.kernel.org/index.php/Todo).
> >
> >I tried to continue the work started by David Ahern
> >(https://github.com/dsahern/linux.git branch:perf-config). This
> >version relies on the features detection tests available in
> >linux/tools/perf/config/feature-checks so as to enable some
> >configuration options (at least by default).
> >
> >This little task is not complete; more Kconfig options should be added
> >for each perf tool (top, record, report, ...).
> >
> >I just wanted to ask whether you consider this proposal as interesting
> >enough for inclusion and if you are ok with the way it is implemented.
> >
> >The code is available here: https://github.com/aberlemont/linux.git
> >- branch: perf-config.
> 
> I know Jiri has an attempt in his tree and there have been a few
> discussions since then as well. I'll take a look at it next week. I
> would like to see it completed; I just don't have the time to do it.

hi,
my latest branch (out of sync for long time) for kbuild:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/kbuild9

I'll check your changes ;-)

jirka
