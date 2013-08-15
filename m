Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab3HOJZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 05:25:19 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41719 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3HOJZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 05:25:17 -0400
Message-ID: <520C9E78.2020401@gmail.com>
Date: Thu, 15 Aug 2013 11:25:12 +0200
From: Ben Tebulin <tebulin@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>
CC: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug] Reproducible data corruption on i5-3340M: Please revert
 53a59fc67!
References: <52050382.9060802@gmail.com> <520BB225.8030807@gmail.com> <20130814174039.GA24033@dhcp22.suse.cz> <CA+55aFwAz7GdcB6nC0Th42y8eAM591sKO1=mYh5SWgyuDdHzcA@mail.gmail.com> <20130814182756.GD24033@dhcp22.suse.cz> <CA+55aFxB6Wyj3G3Ju8E7bjH-706vi3vysuATUZ13h1tdYbCbnQ@mail.gmail.com>
In-Reply-To: <CA+55aFxB6Wyj3G3Ju8E7bjH-706vi3vysuATUZ13h1tdYbCbnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.08.2013 20:35, schrieb Linus Torvalds:
> Yes, the bug was originally introduced in 597e1c35, but in practice it
> never happened, [...]
> 
> NOTE! I still absolutely want Ben to actually test that fix (ie
> backport commit e6c495a96ce0 to his tree), because without testing
> this is all just theoretical, and there might be other things hiding
> here.[..]

I just cherry-picked e6c495a96ce0 into 3.9.11 and 3.7.10.
Unfortunately this does _not resolve_ my issue (too good to be true) :-(
