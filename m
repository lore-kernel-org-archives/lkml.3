Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab3CQO3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:29:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43742 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756277Ab3CQO3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:29:41 -0400
Date: Sun, 17 Mar 2013 14:29:29 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH 1/3] ARM: Clear IDIVT hwcap if CONFIG_ARM_THUMB=n
Message-ID: <20130317142929.GD19071@mudshark.cambridge.arm.com>
References: <1363138321-27849-1-git-send-email-sboyd@codeaurora.org>
 <1363138321-27849-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363138321-27849-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 01:31:59AM +0000, Stephen Boyd wrote:
> Don't advertise support for the SDIV/UDIV thumb instructions if
> the kernel is not compiled with support for thumb userspace. This
> is in line with how we remove the THUMB hwcap in these
> configurations.
> 
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Will Deacon <will.deacon@arm.com>

Will
