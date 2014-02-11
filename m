Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaBKKwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:52:34 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:27795 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750776AbaBKKwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:52:30 -0500
Date: Tue, 11 Feb 2014 10:52:24 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Vinayak Kale <vkale@apm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        Dave P Martin <Dave.Martin@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "dirk.behme@gmail.com" <dirk.behme@gmail.com>
Subject: Re: [PATCH RESEND] arm: add DSB after icache flush in
 __flush_icache_all()
Message-ID: <20140211105224.GC3748@arm.com>
References: <1392109811-8525-1-git-send-email-vkale@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392109811-8525-1-git-send-email-vkale@apm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 09:10:11AM +0000, Vinayak Kale wrote:
> Add DSB after icache flush to complete the cache maintenance operation.
> 
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

I guess what you need to do is add:

Cc: <stable@vger.kernel.org>

and send the patch to Russell's patch system (and add any other acks you
may get in the meantime).

-- 
Catalin
