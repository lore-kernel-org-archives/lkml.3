Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaBRKyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:54:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40326 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbaBRKyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:54:37 -0500
Date: Tue, 18 Feb 2014 11:54:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Drew Richardson <drew.richardson@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo <acme@redhat.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Wade Cherry <Wade.Cherry@arm.com>
Subject: Re: Perf Oops on 3.14-rc2
Message-ID: <20140218105434.GO14089@laptop.programming.kicks-ass.net>
References: <20140210221758.GB11542@dreric01-Precision-T1600>
 <20140218101831.GB4178@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218101831.GB4178@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 10:18:31AM +0000, Will Deacon wrote:
> On Mon, Feb 10, 2014 at 10:17:59PM +0000, Drew Richardson wrote:
> > While adding CPU on/offlining support during perf captures I get an
> > Oops both on ARM as well as my desktop x86_64. Below is a small
> > program that duplicates the issue.
> 
> [...]
> 
> FWIW I can reproduce this easily with -rc3 on my x86 laptop running
> hackbench in parallel with a tweaked version of your test (using
> _SC_NPROCESSORS_ONLN instead of _SC_NPROCESSORS_CONF and hotplugging off
> both CPU2 and CPU3).

-ENOTEST
