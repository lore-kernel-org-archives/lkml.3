Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3HQAJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:09:34 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:47354 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab3HQAJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:09:32 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwFx7uhtDTX5vfiYRo+keLmuvxvSFupU4nB8g1KCN-WVg@mail.gmail.com>
References: <52050382.9060802@gmail.com>
	<520BB225.8030807@gmail.com>
	<20130814174039.GA24033@dhcp22.suse.cz>
	<CA+55aFwAz7GdcB6nC0Th42y8eAM591sKO1=mYh5SWgyuDdHzcA@mail.gmail.com>
	<20130814182756.GD24033@dhcp22.suse.cz>
	<CA+55aFxB6Wyj3G3Ju8E7bjH-706vi3vysuATUZ13h1tdYbCbnQ@mail.gmail.com>
	<520C9E78.2020401@gmail.com>
	<CA+55aFy2D2hTc_ina1DvungsCL4WU2OTM=bnVb8sDyDcGVCBEQ@mail.gmail.com>
	<CA+55aFxuUrcod=X2t2yqR_zJ4s1uaCsGB-p1oLTQrG+y+Z2PbA@mail.gmail.com>
	<520D5ED2.9040403@gmail.com>
	<CA+55aFwFx7uhtDTX5vfiYRo+keLmuvxvSFupU4nB8g1KCN-WVg@mail.gmail.com>
Date: Fri, 16 Aug 2013 16:40:57 -0700
Message-ID: <CA+8MBbK7UTHvaU4NtSaKHepTwF0-_BpW-zq3wKgvtAh-VDqOVA@mail.gmail.com>
Subject: Re: [Bug] Reproducible data corruption on i5-3340M: Please continue
 your great work! :-)
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Tebulin <tebulin@googlemail.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 5:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I'll probably delay committing it until tomorrow, in the hope that
> somebody using one of the other architectures will at least ack that
> it compiles. I'm re-attaching the patch (with the two "logn" -> "long"
> fixes) just to encourage that. Hint hint, everybody..

I see I'm too late to supply an Ack for the commit, because it is already in.
But just for completeness sake - all my ia64 configs build OK, and the couple
that get boot tested still appear to be working too.

-Tony
