Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3GOTLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:11:48 -0400
Received: from mail-ye0-f179.google.com ([209.85.213.179]:48461 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab3GOTLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:11:47 -0400
Date: Mon, 15 Jul 2013 16:11:38 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [RFC 0/4] perf tools: Remove event types data
Message-ID: <20130715191138.GA3298@ghostprotocols.net>
References: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
 <1500509.qlU7PPnHQq@hammer82.arch.suse.de>
 <20130710074940.GA1048@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710074940.GA1048@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 10, 2013 at 09:49:40AM +0200, Jiri Olsa escreveu:
> On Wed, Jul 10, 2013 at 08:11:48AM +0200, Thomas Renninger wrote:
> > On Tuesday, July 09, 2013 06:48:55 PM Jiri Olsa wrote:
> > > hi,
> > > following up on the 'perf timechart' FIXME note and changing
> > > its tracepoint match not to use event types data.
> > 
> > Looks sane and pretty straight forward.
> > Still I am not that deep involved in perf to give a Reviewed-by: quickly...

In such cases an "Acked-by:" seems adequate enough, right? I'm merging
this now, so will not add it, but please let us know if that would be
ok, I may go thru some rebase and then would add that line.
 
> thanks, I saw your name in changelog.. wanted to include
> someone who probably uses timechart command ;-)
> 
> > 
> > #define SUPPORT_OLD_POWER_EVENTS
> > could also vanish, maybe with the next round.
> 
> ok
> 
> jirka
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
