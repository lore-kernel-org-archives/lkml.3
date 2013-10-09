Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3JIDVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 23:21:46 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42344 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab3JIDVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 23:21:37 -0400
Date: Wed, 9 Oct 2013 05:21:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Jones <davej@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131009032135.GQ6882@two.firstfloor.org>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
 <20131006164934.GA15167@gmail.com>
 <20131008065938.GA4333@gmail.com>
 <20131008155131.GA31975@redhat.com>
 <5254313F.4030409@gmail.com>
 <20131008162451.GA1848@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008162451.GA1848@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You'd think that, but for whatever reason, ftrace/perf oopses still happen.

Hiding bugs seems like a poor use of the CONFIG option. It would 
be better to figure out a way to catch them earlier. Perhaps
trinity needs to run more often? any chance of a fengguang style nightly
service for mainline?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
