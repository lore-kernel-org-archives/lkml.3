Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab3EPNJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:09:40 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:48946 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab3EPNJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:09:39 -0400
Date: Thu, 16 May 2013 15:09:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [RFC/PATCH 1/2] perf script: Add --time-filter option
Message-ID: <20130516130934.GA9058@gmail.com>
References: <1368609839-19899-1-git-send-email-namhyung@kernel.org>
 <20130515135608.GF17814@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515135608.GF17814@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Wed, May 15, 2013 at 06:23:58PM +0900, Namhyung Kim wrote:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > The --time-filter option is for limiting samples within a range of
> > time.  A time range looks like <time1>-<time2> and at most one of them
> > can be omitted.  For instance:
> 
> It would be more useful for report or inject than for script.

The 2/2 patch does it for report ...

> After all with a script it's trivial to do an own filter.

Utility features/shortcuts are almost always useful, especially if they 
span multiple tools.

Thanks,

	Ingo
