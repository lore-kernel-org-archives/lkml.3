Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaAWNGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:06:36 -0500
Received: from mail-gg0-f182.google.com ([209.85.161.182]:46615 "EHLO
	mail-gg0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaAWNGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:06:32 -0500
Date: Thu, 23 Jan 2014 10:00:16 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 00/24] perf tools: Add support to accumulate hist
 periods (v6)
Message-ID: <20140123130016.GA17572@ghostprotocols.net>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
 <20140122132018.GC1132@krava.brq.redhat.com>
 <CAM9d7cj=5JnY+yLnNpR2Ex+_dbfcZCjup0Sa2tBf84DcoYHEHA@mail.gmail.com>
 <20140123125009.GA1491@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123125009.GA1491@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 23, 2014 at 01:50:10PM +0100, Jiri Olsa escreveu:
> On Wed, Jan 22, 2014 at 11:44:33PM +0000, Namhyung Kim wrote:
> > On Wed, Jan 22, 2014 at 1:20 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > > I have changes on top of this patchset and all looks great, I was
> > > just going throught this again and wanted to send my ack, but it
> > > no longer merges to the acme's perf/core.

> > Thanks, but wasn't it applied to the acme/perf/core?  Now I'm rebasing
> > it onto the acme/perf/core and it applies without any conflicts.  Did
> > you see one?

> hum, I just merged our v6 on acme's perf/core and got conflicts..
> not 100% sure the perf/core was clean though ;-)

I started to go thru this patchset yesterday, and made changes to code
that makes this patchset to not apply, I'll make the needed changes to
have a branch with it and will announce it here when done.

Till then I think tests can be done on Namhyung's git tree instead.

- Arnaldo
 
> > > Could you please send updated version, and I'll finish the
> > > review.. I promise ;-)
> > 
> > Thanks in advance, I'll send out the v7 right soon. :)
> 
> checking.. thanks,
> jirka
