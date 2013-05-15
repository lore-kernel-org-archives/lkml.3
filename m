Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab3EOT3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:29:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578Ab3EOT3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:29:51 -0400
Date: Wed, 15 May 2013 21:28:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCHv3 0/4] perf, signal x86: Fix breakpoint events overflow
 handling
Message-ID: <20130515192847.GB1091@krava.redhat.com>
References: <1367421944-19082-1-git-send-email-jolsa@redhat.com>
 <20130507122948.GD1076@krava.brq.redhat.com>
 <20130515150450.GB2194@krava.brq.redhat.com>
 <20130515165233.GC13916@laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515165233.GC13916@laptop.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 06:52:33PM +0200, Peter Zijlstra wrote:
> On Wed, May 15, 2013 at 05:04:50PM +0200, Jiri Olsa wrote:
> > On Tue, May 07, 2013 at 02:29:48PM +0200, Jiri Olsa wrote:
> > > On Wed, May 01, 2013 at 05:25:40PM +0200, Jiri Olsa wrote:
> > > > hi,
> > > > sending v3 for initial patchset:
> > > > https://lkml.org/lkml/2013/3/1/324
> > > > 
> > > > basically just sending remaining (not pulled) patches,
> > > > with '*-by: *' tags updated.
> > > > 
> > > > v3 changes:
> > > >   - perf test patches already pulled in
> > > >   - added Oleg's Tested-by for signal related patches
> > > >   - added Frederic's Reviewed-by for signal related patches
> > > >   - added Peter's Reviewed-by for perf patch.
> > > 
> > > hi,
> > > 
> > > Thomas, Peter,
> > > any chance you could pull this in?
> > > 
> > > Ingo,
> > > could you please take the perf change (4/4)?
> > > it's reviewed by PeterZ
> 
> Queued them, will shove them Ingo-wards soonish.
> 

thanks,

jirka
