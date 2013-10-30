Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab3J3Tfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:35:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52867 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3J3Tfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:35:43 -0400
Date: Wed, 30 Oct 2013 20:35:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] perf: arch_perf_out_copy_user default
Message-ID: <20131030193538.GQ16117@laptop.programming.kicks-ass.net>
References: <20131030143750.GT19466@laptop.lan>
 <20131030192927.GB27625@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030192927.GB27625@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 07:29:27PM +0000, Will Deacon wrote:
> Yeah, that's weird, because they *do* appear to work! In fact, looking at
> the code in kernel/events/core.c, it looks like __output_copy_user is
> expected to return the number of bytes not copied, 

Oh, cute, double fail.. head hurts.
