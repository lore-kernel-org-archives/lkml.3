Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaIANlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:41:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:57198 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaIANlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:41:15 -0400
Date: Mon, 1 Sep 2014 15:41:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/5] perf, x86: Add INST_RETIRED.ALL workarounds
Message-ID: <20140901134112.GL27892@worktop.ger.corp.intel.com>
References: <1409006611-30741-1-git-send-email-andi@firstfloor.org>
 <1409006611-30741-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409006611-30741-5-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 03:43:30PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> On Broadwell INST_RETIRED.ALL cannot be used with any period
> that doesn't have the lowest 6 bits cleared. And the period
> should not be smaller than 128.
> 
> Add a new callback to enforce this, and set it for Broadwell.
> 
> This is erratum BDM57 and BDM11.

This changelog could do with more words on the solution, esp. such that
you answer Stephanes question.
