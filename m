Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaIVJQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:16:43 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35313 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbaIVJQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:16:42 -0400
Date: Mon, 22 Sep 2014 10:16:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 3.17-rc4 v7 3/6] arm64: Introduce dummy version of
 asm/fiq.h
Message-ID: <20140922091603.GC30085@e104818-lin.cambridge.arm.com>
References: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org>
 <1410970218-28847-4-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410970218-28847-4-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 05:10:15PM +0100, Daniel Thompson wrote:
> Drivers that are shared between arm and arm64 and which employ
> FIQ on arm cannot include asm/fiq.h without #ifdef'ing. This patch
> introduces a dummy version of asm/fiq.h to arm64 to avoid this.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
