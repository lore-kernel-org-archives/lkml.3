Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584AbaEML5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:57:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760028AbaEML5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:57:52 -0400
Date: Tue, 13 May 2014 13:56:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: peterz@infradead.org, acme@infradead.org, jolsa@kernel.org,
        rostedt@goodmis.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf_tools/sched: Remove nr_state_machine_bugs in perf
 latency.
Message-ID: <20140513115658.GA1138@krava.brq.redhat.com>
References: <20140512181946.GG13467@laptop.programming.kicks-ass.net>
 <1399945101-21736-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <53717874.2020200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53717874.2020200@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 10:42:12AM +0900, Dongsheng Yang wrote:
> Hi jiri or Arnaldo,
>     It seems Peter really do not like the usage of
> sched_wakeup(.success), and
> don't plan to support it in scheduler any more.  Please consider to
> append this patch
> too when you take the patch from Peter.  Thanx :)

sure, any acks anyone? ;-)

thanks,
jirka
