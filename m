Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbaIRWzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 18:55:44 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33857 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751978AbaIRWzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 18:55:42 -0400
Date: Thu, 18 Sep 2014 23:55:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] arm: vfp: Bounce undefined instructions in
	vectored mode
Message-ID: <20140918225531.GG5182@n2100.arm.linux.org.uk>
References: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org> <1411076592-6157-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411076592-6157-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 02:43:12PM -0700, Stephen Boyd wrote:
> From: Stepan Moskovchenko <stepanm@codeaurora.org>
> 
> Certain ARM CPU implementations (e.g. Cortex-A15) may not raise a
> floating- point exception whenever deprecated short-vector VFP
> instructions are executed. Instead these instructions are treated
> as UNALLOCATED. Change the VFP exception handling code to emulate
> short-vector instructions even if FPEXC exception bits are not
> set.

Purely out of interest, how much use do these instructions have in
real programs?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
