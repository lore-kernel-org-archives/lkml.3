Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbaILRJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:09:00 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53330 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750833AbaILRI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:08:59 -0400
Date: Fri, 12 Sep 2014 18:08:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 3.17-rc4 v5 2/6] arm: fiq: Replace default FIQ handler
Message-ID: <20140912170851.GN12361@n2100.arm.linux.org.uk>
References: <1410272111-30516-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-3-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410435078-28462-3-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And another thing...

On Thu, Sep 11, 2014 at 12:31:14PM +0100, Daniel Thompson wrote:
> +	.align 5
> +__fiq_abt:
> +	svc_entry 0, 0

Right, so this function is called __fiq_abt.
...
> +	svc_exit_via_fiq
> + UNWIND(.fnend		)
> +ENDPROC(__fiq_svc)

Or is it called __fiq_svc ?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
