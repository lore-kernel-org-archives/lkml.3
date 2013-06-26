Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3FZRL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:11:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38390 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab3FZRL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:11:28 -0400
Date: Wed, 26 Jun 2013 19:11:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com
Subject: Re: [PATCH 0/7] perf, x86: Haswell LBR call stack support
Message-ID: <20130626171109.GN28407@twins.programming.kicks-ass.net>
References: <1372150039-15151-1-git-send-email-zheng.z.yan@intel.com>
 <20130626120749.GH28407@twins.programming.kicks-ass.net>
 <20130626165942.GF6123@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626165942.GF6123@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 06:59:42PM +0200, Andi Kleen wrote:
> > These patches are also done wrong; the first patches should add HSW
> > support for the existing features. Only then should you do patches for
> > new fail^wfeatures.
> 
> The basic Haswell LBR support is already in tip.

D'uh indeed. Sorry for the noise.
