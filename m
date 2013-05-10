Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab3EJKaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:30:46 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58420
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637Ab3EJKap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:30:45 -0400
Date: Fri, 10 May 2013 12:29:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave@sr71.net>
Cc: Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        eranian@google.com
Subject: Re: NMIs induced by 'perf top' hogging all CPU time
Message-ID: <20130510102911.GB31235@dyad.programming.kicks-ass.net>
References: <518C314C.9040905@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518C314C.9040905@sr71.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 04:29:16PM -0700, Dave Hansen wrote:
> If I boot a recent kernel (bb9055b) and run 'perf top' on my machine, it
> hangs.  It is 100% reproducible; it happens every single time.  If I'm
> lucky, I'll get some of the hardlockup detection messages on the console.

Are you implicitly saying it worked as expected on previous kernels?
