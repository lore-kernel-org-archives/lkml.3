Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3EJMlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:41:42 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:48341 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3EJMll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:41:41 -0400
Date: Fri, 10 May 2013 08:41:38 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/1] ARM: mcpm: Fix build error with gic_secondary_init
 call
In-Reply-To: <1368166526-12525-1-git-send-email-sachin.kamat@linaro.org>
Message-ID: <alpine.LFD.2.03.1305100840390.13109@syhkavp.arg>
References: <1368166526-12525-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-875375415-1368189699=:13109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-875375415-1368189699=:13109
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 10 May 2013, Sachin Kamat wrote:

> Commit c0114709ed ("irqchip: gic: Perform the gic_secondary_init()
> call via CPU notifier") removed all platform calls to gic_secondary_init.
> Since this file got merged after the removal of the above call, this
> function got left out in the current file which is causing the following
> build error:
> arch/arm/common/mcpm_platsmp.c:52:2: error: implicit declaration of function
> ‘gic_secondary_init’ [-Werror=implicit-function-declaration]
> gic_secondary_init(0);
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Nicolas Pitre <nico@linaro.org>

I already submitted a patch to fix this:
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7715/1


Nicolas
--8323328-875375415-1368189699=:13109--
