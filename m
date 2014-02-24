Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaBXPs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:48:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:31445 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbaBXPs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:48:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,535,1389772800"; 
   d="scan'208";a="461200162"
Date: Mon, 24 Feb 2014 07:48:41 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the tip tree
Message-ID: <20140224154841.GG12219@tassilo.jf.intel.com>
References: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess that there may be more places where "asmlinkage" is used with
> "static" - I assume that they are all incorrect?

Likely they are bogus yes.

One issue is still the changed ABI on i386, so one has to double check
before removing if they have arguments.

-Andi
