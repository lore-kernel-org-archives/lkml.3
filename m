Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaAOSa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:30:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45667 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbaAOSaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:30:17 -0500
Date: Wed, 15 Jan 2014 19:30:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] perf, ibs: Fix waking up from S3 for AMD family 10h
Message-ID: <20140115183001.GL31570@twins.programming.kicks-ass.net>
References: <1389797849-5565-1-git-send-email-rric.net@gmail.com>
 <20140115180313.GA8360@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115180313.GA8360@rric.localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 07:03:13PM +0100, Robert Richter wrote:
> On 15.01.14 15:57:29, Robert Richter wrote:
> > @@ -816,6 +817,18 @@ static int force_ibs_eilvt_setup(void)
> >  	return ret;
> >  }
> >  
> > +void ibs_eilvt_setup(void)
> 
> Grrr, this is not static. Could this be changed when the patch is
> applied assuming the rest is ok? Otherwise I will send an update.

+static, fixed
