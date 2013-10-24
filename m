Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3JXM1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:27:55 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:44741 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab3JXM1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:27:54 -0400
Date: Thu, 24 Oct 2013 09:27:48 -0300
From: Arnaldo Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf session: Add option to copy events when queueing
Message-ID: <20131024122748.GC6539@ghostprotocols.net>
References: <1378496221-61525-1-git-send-email-dsahern@gmail.com>
 <20130914161626.GD1718@localhost.localdomain>
 <CAFTL4hx=ycrepky0P3DYwoFBgknYumW6+tpW7PygqGD2ZNDFqg@mail.gmail.com>
 <5268F524.20505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5268F524.20505@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 24, 2013 at 11:23:32AM +0100, David Ahern escreveu:
> On 10/24/13 10:30 AM, Frederic Weisbecker wrote:
> >Bah, checking that again, there don't seem to be a bug there. Actually
> >the sample buffer is reset after we pick the last entry. So it looks
> >all fine. I got confused as usual. Nevermind.
> 
> Ok. I had not come back to this thread since I decided on a
> different route for the event copying. I'll take it out of my to-do
> list.

Can you elaborate on that?

I had this feeling that perhaps we could defer copying the event till it
would be overwritten, something like making a range read only and then
when the event would be _really_ consumed the tooling would mark it as
so... Have to think about it more tho :-\

- Arnaldo
