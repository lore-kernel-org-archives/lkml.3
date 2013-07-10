Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3GJHuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:50:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab3GJHuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:50:24 -0400
Date: Wed, 10 Jul 2013 09:49:40 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [RFC 0/4] perf tools: Remove event types data
Message-ID: <20130710074940.GA1048@krava.brq.redhat.com>
References: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
 <1500509.qlU7PPnHQq@hammer82.arch.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500509.qlU7PPnHQq@hammer82.arch.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 08:11:48AM +0200, Thomas Renninger wrote:
> On Tuesday, July 09, 2013 06:48:55 PM Jiri Olsa wrote:
> > hi,
> > following up on the 'perf timechart' FIXME note and changing
> > its tracepoint match not to use event types data.
> 
> Looks sane and pretty straight forward.
> Still I am not that deep involved in perf to give a Reviewed-by: quickly...

thanks, I saw your name in changelog.. wanted to include
someone who probably uses timechart command ;-)

> 
> #define SUPPORT_OLD_POWER_EVENTS
> could also vanish, maybe with the next round.

ok

jirka
