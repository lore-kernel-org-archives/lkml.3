Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaBRLE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 06:04:26 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53536 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656AbaBRLEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 06:04:25 -0500
Date: Tue, 18 Feb 2014 11:03:54 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Drew Richardson <Drew.Richardson@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo <acme@redhat.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Wade Cherry <Wade.Cherry@arm.com>
Subject: Re: Perf Oops on 3.14-rc2
Message-ID: <20140218110354.GE4178@mudshark.cambridge.arm.com>
References: <20140210221758.GB11542@dreric01-Precision-T1600>
 <20140218101831.GB4178@mudshark.cambridge.arm.com>
 <20140218105200.GN14089@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218105200.GN14089@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 10:52:00AM +0000, Peter Zijlstra wrote:
> On Tue, Feb 18, 2014 at 10:18:31AM +0000, Will Deacon wrote:
> > I've included part of the log below, but I also saw a WARN which I
> > unfortunately only managed to get a photo of.
> > 
> >   http://www.willdeacon.ukfsn.org/bitbucket/oopsen/x86/
> > 
> 
> Known issue that; we've been chasing it for a while. The most recent
> thread can be found here:
> 
>   lkml.kernel.org/r/20140130190253.GA11819@redhat.com

Thanks for the pointer, Peter.

Will
