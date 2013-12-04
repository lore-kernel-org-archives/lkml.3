Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3LDKAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:00:14 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:50485 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab3LDKAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:00:09 -0500
Date: Wed, 4 Dec 2013 11:00:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@iki.fi>
Subject: Re: [PATCH 1/3] perf tools: Record total sampling time
Message-ID: <20131204100005.GA2363@gmail.com>
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
 <1385967199-3759-2-git-send-email-namhyung@kernel.org>
 <20131202124527.GB22212@gmail.com>
 <20131202125709.GA22404@gmail.com>
 <1385999009.1710.72.camel@leonhard>
 <20131202163620.GC27781@gmail.com>
 <20131202202459.GF17149@ghostprotocols.net>
 <87y542mqts.fsf@sejong.aot.lge.com>
 <529DEAEE.6020708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529DEAEE.6020708@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 12/2/13, 10:44 PM, Namhyung Kim wrote:
> >>Right now 'perf stat -i' i used for '--no-inherit', perhaps we can just
> >>have --no-inherit have no short option and grab -i to have the same
> >>meaning as in 'report', 'script', etc.
> >
> >Agreed.  Maybe we could change it to plain --inherit.
> 
> yes: https://lkml.org/lkml/2013/11/19/330

agreed.

Thanks,

	Ingo
