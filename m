Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab3GER0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 13:26:46 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:34984 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab3GER0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 13:26:45 -0400
Date: Fri, 5 Jul 2013 14:26:37 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v2] perf record: fix symbol processing bug and greatly
 improve performance
Message-ID: <20130705172637.GA16414@ghostprotocols.net>
References: <1368110568-64714-1-git-send-email-Waiman.Long@hp.com>
 <20130510081214.GA6848@gmail.com>
 <51D6FDBD.6010606@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D6FDBD.6010606@hp.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 05, 2013 at 01:09:17PM -0400, Waiman Long escreveu:
> On 05/10/2013 04:12 AM, Ingo Molnar wrote:
> >* Waiman Long<Waiman.Long@hp.com>  wrote:

> >>  3 files changed, 11 insertions(+), 4 deletions(-)
> >Acked-by: Ingo Molnar<mingo@kernel.org>

> Thank for the Ack. Will that patch go into v3.11?

I'm back at processing patches, I'm putting everything on the perf/core
branch and afterwards will go thru the queue looking for pure bug fixex
to put on perf/urgent and send to Ingo.

- Arnaldo
