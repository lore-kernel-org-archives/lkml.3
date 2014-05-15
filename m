Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaEOTMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:12:34 -0400
Received: from one.firstfloor.org ([193.170.194.197]:36036 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaEOTMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:12:33 -0400
Date: Thu, 15 May 2014 21:12:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com
Subject: Re: perf: Add support for full Intel event lists v3
Message-ID: <20140515191231.GC1873@two.firstfloor.org>
References: <1399935074-25167-1-git-send-email-andi@firstfloor.org>
 <CAPh34me=yxjs2LR+_eiTyrQKFzDDtr95i_3+HDwHPPxYfZDLqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPh34me=yxjs2LR+_eiTyrQKFzDDtr95i_3+HDwHPPxYfZDLqw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 06:09:20PM +0200, Hagen Paul Pfeifer wrote:
> On 13 May 2014 00:51, Andi Kleen <andi@firstfloor.org> wrote:
> 
> > I implemented an automatic downloader to get the event file for the
> > current CPU.  The events are stored in ~/.events.
> > Then perf adds a parser that converts the JSON format into perf event
> > aliases, which then can be used directly as any other perf event.
> 
> Should the name of the file not more specific? I mean .events can mean
> everything? Every program may have a demand for this generic name. Why
> not ~/.perf-events? Even more standard [1]:
> $XDG_CACHE_HOME/perf/events (i.e. ~/.cache/perf/events)

It's already pmu-events, but I forgot to update the description.

-Andi
