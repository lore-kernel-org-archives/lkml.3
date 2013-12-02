Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab3LBTjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:39:06 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:63055 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab3LBTi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:38:59 -0500
Date: Mon, 2 Dec 2013 16:38:50 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] perf report: Add --show-time-info option
Message-ID: <20131202193850.GC17149@ghostprotocols.net>
References: <20131202192315.GA17149@ghostprotocols.net>
 <529CDEA6.8000807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529CDEA6.8000807@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 02, 2013 at 12:25:26PM -0700, David Ahern escreveu:
> On 12/2/13, 12:23 PM, Arnaldo Carvalho de Melo wrote:
> >Em Mon, Dec 02, 2013 at 11:38:20PM +0900, Namhyung Kim escreveu:
> >>2013-12-02 (월), 09:33 -0300, Arnaldo Carvalho de Melo:
> >>>Em Mon, Dec 02, 2013 at 03:53:19PM +0900, Namhyung Kim escreveu:
> >>>>From: Namhyung Kim <namhyung.kim@lge.com>

> >>>>The --show-time-info option is for displaying elapsed sampling time

> >>>Isn't that too long? Can't we use just --time/-t?

> >>Hmm.. interesting.  Your previous feedback was to use longer and clearer
> >>option name. :)

> >>https://lkml.org/lkml/2013/11/18/198

> >Hey, longer and more descriptive names _when required_, in that case I
> >thought that even being longer --show-task-events would be better, but
> >here using --show-time-info the 'info' part looks superfluous, at least
> >to me, hence my suggestion/question :-)

> I thought -t/--time is going to be used to specify a time interval?
> Collect data for N-seconds, analyze some middle M-seconds.

Can you suggest a better name for the option being discussed?

Perhaps one of:

--show-event-time
--event-time

?

As a policy I think we should go on adding just long options and only
after there is a really strong case we should use a short option for
really, really popular options.

- Arnaldo
