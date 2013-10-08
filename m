Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3JHPwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab3JHPwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:52:54 -0400
Date: Tue, 8 Oct 2013 11:51:31 -0400
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131008155131.GA31975@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
	x86@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
	Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
 <20131006164934.GA15167@gmail.com>
 <20131008065938.GA4333@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008065938.GA4333@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 08:59:38AM +0200, Ingo Molnar wrote:
 
 > You might want to concentrate your efforts from fighting perf 
 > functionality towards decreasing per tracepoint overhead instead,
 > without hurting kernel functionality and maintainability.
 
Making it easier to disable perf entirely would be desirable for one use case.
I can't do a trinity run for more than a few hours for the last few months
without hitting perf/ftrace bugs that no-one seems to be able to get their
heads around.

It would be useful if I could in the meantime find bugs in other parts of the
kernel by disabling all the affected code.
 
	Dave

