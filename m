Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab3FZQ7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:59:45 -0400
Received: from one.firstfloor.org ([193.170.194.197]:37787 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3FZQ7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:59:44 -0400
Date: Wed, 26 Jun 2013 18:59:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH 0/7] perf, x86: Haswell LBR call stack support
Message-ID: <20130626165942.GF6123@two.firstfloor.org>
References: <1372150039-15151-1-git-send-email-zheng.z.yan@intel.com>
 <20130626120749.GH28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626120749.GH28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> These patches are also done wrong; the first patches should add HSW
> support for the existing features. Only then should you do patches for
> new fail^wfeatures.

The basic Haswell LBR support is already in tip.

It's pretty much the same as Sandy Bridge, except the the sign
extension need to extend two additional bits.

The only other part not yet in are the exposed filters for INTX/ABORT, plus
the workaround for the duplicated ABORT record. These are orthogonal
to callstack LBR.

-Andi
