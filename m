Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbaIIJ2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:28:11 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:50359 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755200AbaIIJ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:28:09 -0400
Message-ID: <1410254887.22255.14.camel@x220>
Subject: Re: [PATCH] arm64, defconfig: Increase NR_CPUS default to 64
From: Paul Bolle <pebolle@tiscali.nl>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Robert Richter <rric@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Robert Richter <rrichter@cavium.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Tue, 09 Sep 2014 11:28:07 +0200
In-Reply-To: <20140909080740.GP23009@pengutronix.de>
References: <1410176689-20020-1-git-send-email-rric@kernel.org>
	 <20140909080740.GP23009@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Sep 2014 09:28:07.0277 (UTC) FILETIME=[5D3BB1D0:01CFCC10]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-09 at 10:07 +0200, Uwe Kleine-König wrote:
> On Mon, Sep 08, 2014 at 01:44:48PM +0200, Robert Richter wrote:
> > @@ -252,11 +252,11 @@ config SCHED_SMT
> >  	  places. If unsure say N here.
> >  
> >  config NR_CPUS
> > -	int "Maximum number of CPUs (2-32)"
> > -	range 2 32
> > +	int "Maximum number of CPUs (2-64)"
> > +	range 2 64
> >  	depends on SMP
> >  	# These have to remain sorted largest to smallest
> Unrelated to the patch: What does this comment mean? There is only one
> line following, so it's sorted implicitly.

This comment doesn't mean much, anymore.

It was added in commit 159428538323 ("arm64: Add Kconfig option for APM
X-Gene SOC family"). Why someone cared so much about the sorting of the
two defaults is unclear to me. Maybe only to make sure future commits
wouldn't mess up the sorting order. Anyhow, it seems it was just
forgotten to remove that line in commit 62aceb8ff4b3 ("arm64: make
default NR_CPUS 8") which again made it a single item list.

> > -	default "8"
> > +	default "64"


Paul Bolle

