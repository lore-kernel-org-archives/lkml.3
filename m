Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaK0Kax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:30:53 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:37359 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaK0Kaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:30:39 -0500
Date: Thu, 27 Nov 2014 10:30:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Update processor_modes for hyp and monitor mode
Message-ID: <20141127103023.GM3836@n2100.arm.linux.org.uk>
References: <1416272732-20573-1-git-send-email-sboyd@codeaurora.org>
 <54768461.3050501@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54768461.3050501@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 05:54:41PM -0800, Stephen Boyd wrote:
> On 11/17/2014 05:05 PM, Stephen Boyd wrote:
> >If the kernel is running in hypervisor mode or monitor mode we'll
> >print UK6_32 or UK10_32 if we call into __show_regs(). Let's
> >update these strings to indicate the new modes that didn't exist
> >when this code was written.
> >
> >Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >---
> 
> Can I throw this into the patch tracker?

Yep.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
