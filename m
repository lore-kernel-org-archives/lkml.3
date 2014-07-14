Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbaGNWm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:42:29 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:31973 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757021AbaGNWm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:42:26 -0400
Date: Mon, 14 Jul 2014 23:41:59 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joel Schopp <joel.schopp@amd.com>
Cc: Timur Tabi <timur@codeaurora.org>, Jungseok Lee <jungseoklee85@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "ilho215.lee@samsung.com" <ilho215.lee@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "barami97@gmail.com" <barami97@gmail.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 2/7] arm64: Introduce VA_BITS and translation level
 options
Message-ID: <20140714224159.GA9829@arm.com>
References: <000101cf6dc6$3b93d510$b2bb7f30$@samsung.com>
 <CAOZdJXWCu-zHuQoAUdiieqsKqCfG9BsZariFqQP=NCgQP-zpNA@mail.gmail.com>
 <53C43FE3.1050008@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C43FE3.1050008@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 09:38:59PM +0100, Joel Schopp wrote:
> I agree that these patches would be very useful.  I just rebased my fix
> for a VTTBR_BADDR_MASK bug on one of these patches that could be pulled
> out independently.  See
> https://lists.cs.columbia.edu/pipermail/kvmarm/2014-July/010480.html
> 
> The original author Jungseok Lee is no longer available to work on
> future versions of these patches.  I was thinking that if they didn't
> get picked up as they are that with the original author's blessing I
> would pick them up and keep them forward ported/resubmitted.  I have an
> SOC to test them on.

The patches are pretty good. I'll give them a try tomorrow and if there
isn't something fundamental missing I'll consider taking them for 3.17.

-- 
Catalin
