Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaIORS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 13:18:56 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33067 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaIORSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 13:18:55 -0400
Message-ID: <1410801517.3817.13.camel@hornet>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
From: Pawel Moll <pawel.moll@arm.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Mon, 15 Sep 2014 18:18:37 +0100
In-Reply-To: <5415B790.5010607@gmail.com>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>
	 <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
	 <54132F63.1010401@gmail.com> <20140912204444.GA11199@kernel.org>
	 <5415B790.5010607@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-09-14 at 16:43 +0100, David Ahern wrote:
> >> Seems really similar to what I proposed in the past:

Yeah, it wasn't really hard to come with similar conclusions :-)

> >> https://lkml.org/lkml/2011/2/27/159
> >>
> >> Which was rejected.
> >
> > I took a look at that thread, but just barely, emphasis on that.
> >
> > Injecting something from userspace, a la ftrace, seems to be something,
> > as tglx mentioned, "buried" in that patchset.
> 
> Thomas object to an ioctl buried deep in a patch -- newbie mistake.
> 
> Peter objected to the ioctl https://lkml.org/lkml/2011/3/1/229
> 
> It was not userspace injecting random data into the stream but rather 
> forcing the sample to be generated and added to the stream.

I would like to hear from Peter and others. If not here, I'll get them
to talk next month on Linux Plumbers :-)

Pawel

