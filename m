Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3FNIWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:22:30 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:36809 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3FNIW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:22:28 -0400
Date: Fri, 14 Jun 2013 10:22:20 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] irqdomain: Remove temporary MIPS workaround code
Message-ID: <20130614082220.GC22589@linux-mips.org>
References: <1371165583-21907-1-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371165583-21907-1-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 12:19:43AM +0100, Grant Likely wrote:

> The MIPS interrupt controllers are all registering their own irq_domains
> now. Drop the MIPS specific code because it is no longer needed.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: linux-mips@linux-mips.org
> ---
> 
> Ralf, this should be okay to pull out now. I'll be submitting it for
> v3.11 unless someone yells. Even if so, all the irqdomain infrastructure
> is in place to make it trivial to add an irqdomain where missing.

I would like to merge this through the MIPS tree so it'll receive
maximum testing, just in case, ok?

  Ralf
