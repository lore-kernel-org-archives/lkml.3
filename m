Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab3FZP36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:29:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32815 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3FZP34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:29:56 -0400
Date: Wed, 26 Jun 2013 12:42:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <bitbucket@online.de>, Dave Chiluk <chiluk@canonical.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler accounting inflated for io bound processes.
Message-ID: <20130626104243.GE28407@twins.programming.kicks-ass.net>
References: <51C35C05.1070005@canonical.com>
 <1372176104.7497.86.camel@marge.simpson.net>
 <1372182534.7497.129.camel@marge.simpson.net>
 <20130626093713.GA27385@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626093713.GA27385@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 11:37:13AM +0200, Ingo Molnar wrote:
> Would be very nice to randomize the sampling rate, by randomizing the 
> intervals within a 1% range or so - perf tooling will probably recognize 
> the different weights.

You're suggesting adding noise to the regular kernel tick?
