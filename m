Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaCUVh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:37:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:48995 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbaCUVhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:37:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,705,1389772800"; 
   d="scan'208";a="497120787"
Date: Fri, 21 Mar 2014 14:37:53 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Wu <peter@lekensteyn.nl>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
Message-ID: <20140321213753.GK3132@tassilo.jf.intel.com>
References: <4055058.qLAukpngnj@al>
 <20140321192938.GJ3132@tassilo.jf.intel.com>
 <970fd799-8d4c-4759-8a96-1291b411f307@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <970fd799-8d4c-4759-8a96-1291b411f307@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 01:46:04PM -0700, H. Peter Anvin wrote:
> Not really.  That is equally braindamaged.  The problem is that KVM is telling the host that our is something it simply cannot be.

Well it has to pick something. It's unlikely it will ever implement 100% of that particular CPU.
0 is the best you can get in many cases.

Also I thought Xen did return 0.

-Andi
