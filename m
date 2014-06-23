Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaFWI5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:57:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:46397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbaFWIzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:55:24 -0400
Date: Mon, 23 Jun 2014 10:55:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Micro-optimization in nhmex_rbox_get_constraint
Message-ID: <20140623085521.GM19860@laptop.programming.kicks-ass.net>
References: <1403183731-15402-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403183731-15402-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 03:15:31PM +0200, Rasmus Villemoes wrote:
> Flipping the LSB doesn't require four lines of code. This shaves a few
> bytes of the generated code, including a branch.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Thanks!
