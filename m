Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab3LGR3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 12:29:30 -0500
Received: from one.firstfloor.org ([193.170.194.197]:57221 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3LGR31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 12:29:27 -0500
Date: Sat, 7 Dec 2013 18:29:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>, lenb@kernel.org,
        tglx@linutronix.de, peterz@infradead.org
Subject: Re: [PATCH] Trace idle entry and exit times
Message-ID: <20131207172926.GD21717@two.firstfloor.org>
References: <1386377164-2223-1-git-send-email-andi@firstfloor.org>
 <1386392252.5673.31.camel@marge.simpson.net>
 <20131207052029.GC21717@two.firstfloor.org>
 <1386404544.5673.88.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386404544.5673.88.camel@marge.simpson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well that one is obvious. I mean more the subtle problems.
> 
> Yeah, not subtle.  SGI could use C2 as power supply stress tester.

This is only on system where the APIC timer does not tick in deep idle.
At this point these are 5+ year old systems.

There were some ideas of breaking up that lock, but they were never
fully implemented.

-Andi
