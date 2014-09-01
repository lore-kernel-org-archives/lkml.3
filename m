Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaIANvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:51:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:57240 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaIANvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:51:00 -0400
Date: Mon, 1 Sep 2014 15:50:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/5] perf, x86: Document all Haswell models
Message-ID: <20140901135059.GM27892@worktop.ger.corp.intel.com>
References: <1409006611-30741-1-git-send-email-andi@firstfloor.org>
 <1409006611-30741-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409006611-30741-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 03:43:28PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add names for each Haswell model as requested by Peter.
> 
> v2: Remove Crystall Well name.


> +	case 60: /* 22nm Haswell Client */
> +	case 70: /* 22nm Haswell Client */
> +	case 63: /* 22nm Haswell Server */
> +	case 69: /* 22nm Haswell ULT */

That's inconsistent with all the others. I gave you one that makes
sense, why not use it?
