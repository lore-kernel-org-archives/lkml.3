Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaGAMPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:15:54 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49580 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751605AbaGAMPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:15:52 -0400
Date: Tue, 1 Jul 2014 13:15:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alex Elder <elder@linaro.org>
Cc: bcm@fixthebug.org, mporter@linaro.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mach-bcm SMC: address clang inline asm incompatibility
Message-ID: <20140701121544.GK32514@n2100.arm.linux.org.uk>
References: <1404216339-6480-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404216339-6480-1-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 07:05:39AM -0500, Alex Elder wrote:
> My GCC-based build environment likes to call register r12 by the
> name "ip" in inline asm.  Behan Webster informed me that his Clang-
> based build environment likes "r12" instead.

Two objections, one of which is an acceptable outcome:
1. Why can't clang just learn these alternative names?
2. Why can't we just use "r12" here?

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
