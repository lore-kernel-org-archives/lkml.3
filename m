Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbbAGLmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:42:42 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:53796 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbbAGLml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:42:41 -0500
Date: Wed, 7 Jan 2015 12:42:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] perf, x86, uncore, hsw-ep: Handle systems with only two
 SBOXes
Message-ID: <20150107114235.GF23965@worktop.programming.kicks-ass.net>
References: <1420583675-9163-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420583675-9163-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 02:34:35PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> There was another report of a boot failure with a #GP fault in the
> uncore SBOX initialization. The earlier work around was not enough
> for this system.
> 
> The boot was failing while trying to initialize the third SBOX.
> 
> This patch detects parts with only two SBOXes and limits the number
> of SBOX units to two there.
> 

Thanks!
