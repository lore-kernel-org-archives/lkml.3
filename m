Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab3KKP46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:56:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37346 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab3KKP4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:56:52 -0500
Date: Mon, 11 Nov 2013 16:56:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v5 0/9] liblockdep: userspace lockdep
Message-ID: <20131111155637.GL19203@twins.programming.kicks-ass.net>
References: <20130626122408.GJ28407@twins.programming.kicks-ass.net>
 <20130626155325.GB7399@gmail.com>
 <51CB4328.7010006@oracle.com>
 <20130627090722.GC4398@gmail.com>
 <51CC4461.50207@oracle.com>
 <51DA127E.3040706@oracle.com>
 <20130708083914.GB3948@gmail.com>
 <5231FCA1.4090803@oracle.com>
 <20130912180120.GB32511@gmail.com>
 <527D1992.9000209@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527D1992.9000209@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 12:04:18PM -0500, Sasha Levin wrote:
> >If Peter agrees with them and picks them up then the next merge window
> >would be fine I guess.

OK, picked them up; not sure it'll still make this window though :/
