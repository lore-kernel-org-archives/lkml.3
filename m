Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3J1KA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:00:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46770 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab3J1KA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:00:56 -0400
Date: Mon, 28 Oct 2013 11:00:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: PERF_EVENT_IOC_PERIOD on ARM vs everywhere else
Message-ID: <20131028100049.GK19466@laptop.lan>
References: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu>
 <20131028085700.GB20218@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028085700.GB20218@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 08:57:00AM +0000, Will Deacon wrote:
> > Should other architectures be updated to?  I just wanted to find out the 
> > rationale for this before I update the manpage to reflect the difference 
> > in behaviors between architectures.
> 
> I don't want to be the `oddball' architecture (at least, not more than I am
> already :), but I do find it tricky to follow the required semantics of perf
> as opposed to `it happens to work this way', especially when so much of it
> is buried in the various arch backends. So if somebody using the thing on
> ARM has (what looks to me like) a valid issue, then I usually try and fix
> it.

Hurmph.. at least raise the issue for the other archs.
