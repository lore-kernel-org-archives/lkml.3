Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaIATEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 15:04:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49839 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaIATEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 15:04:43 -0400
Date: Mon, 1 Sep 2014 21:04:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: Tree for Aug 23
Message-ID: <20140901190438.GB5806@worktop.ger.corp.intel.com>
References: <20140823080422.7895575c@canb.auug.org.au>
 <20140825045741.GA29723@roeck-us.net>
 <20140901155804.GT27892@worktop.ger.corp.intel.com>
 <5404A2F2.3090908@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5404A2F2.3090908@roeck-us.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 09:46:42AM -0700, Guenter Roeck wrote:
> Yes, the problem is still seen in next-140829. See qemu test results at
> http://server.roeck-us.net:8010/builders.
> 
> I provided sparc64 images at http://server.roeck-us.net/qemu/sparc64/.
> The README file includes instructions on how to run the image in qemu
> and how to build a kernel.
> 
> I can do the same for mips and mips64 if needed; let me know.

Thanks, that's enough to get started.
