Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbaISWZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 18:25:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59245 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaISWZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 18:25:46 -0400
Message-ID: <541CAD68.2090009@codeaurora.org>
Date: Fri, 19 Sep 2014 15:25:44 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>, LKML <linux-kernel@vger.kernel.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 10/11] ARM: kernel: add support for cpu cache information
References: <1409763617-17074-1-git-send-email-sudeep.holla@arm.com> <1409763617-17074-11-git-send-email-sudeep.holla@arm.com>
In-Reply-To: <1409763617-17074-11-git-send-email-sudeep.holla@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/14 10:00, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
>
> This patch adds support for cacheinfo on ARM platforms.
>
> On ARMv7, the cache hierarchy can be identified through Cache Level ID
> register(CLIDR) while the cache geometry is provided by Cache Size ID
> register(CCSIDR).
>
> On architecture versions before ARMv7, CLIDR and CCSIDR is not
> implemented. The cache type register(CTR) provides both cache hierarchy
> and geometry if implemented. For implementations that doesn't support
> CTR, we need to list the probable value of CTR if it was implemented
> along with the cpuid for the sake of simplicity to handle them.
>
> Since the architecture doesn't provide any way of detecting the cpus
> sharing particular cache, device tree is used fo the same purpose.
> On non-DT platforms, first level caches are per-cpu while higher level
> caches are assumed system-wide.
>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
>

Tested-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

