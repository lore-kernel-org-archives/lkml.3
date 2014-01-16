Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaAPIZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 03:25:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaAPIZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 03:25:15 -0500
Date: Thu, 16 Jan 2014 09:24:55 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH/RFC] perf ui/tui: Show column header in hist browser
Message-ID: <20140116082455.GA1301@krava.brq.redhat.com>
References: <1389762525-1795-1-git-send-email-namhyung@kernel.org>
 <20140115121044.GA1669@krava.redhat.com>
 <20140115141314.GA16016@ghostprotocols.net>
 <87ppns92q8.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppns92q8.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 09:42:23AM +0900, Namhyung Kim wrote:
> Hi Arnaldo and Jiri,
> 
> On Wed, 15 Jan 2014 11:13:14 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Jan 15, 2014 at 01:10:44PM +0100, Jiri Olsa escreveu:
> >> On Wed, Jan 15, 2014 at 02:08:45PM +0900, Namhyung Kim wrote:
> >> > Add a line for showing column headers like --stdio.
> >> 
> >> https://git.kernel.org/cgit/linux/kernel/git/jolsa/perf.git/commit/?h=perf/lock12&id=1a06d77629cb8870838132688f443b9ca1436026
> >> 
> >> ;-) I'll check your change
> >
> > From a quick view, your change looks better, i.e. being able to toggle
> > the header line.
> >
> > Please let me know what you guys end up agreeing is best.
> 
> Yes, looking at the source, Jiri's version looks much better.  I was
> lazy for sorting column width and supporting a hotkey for toggling. :)
> I just wanted to see how you guys think, so the rfc.

ok, I'll send it out soon with my other changes

thanks,
jirka
