Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302Ab3HGVxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:53:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33533 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518Ab3HGVxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:53:01 -0400
Date: Wed, 7 Aug 2013 14:52:59 -0700
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: Re: [GIT PULL] msm cleanups for v3.12
Message-ID: <20130807215259.GA22852@codeaurora.org>
References: <1375909096-22088-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1375909096-22088-1-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 01:58:16PM -0700, David Brown wrote:
>The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:
>
>  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)
>
>are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git for-3.12/msm-cleanup2
>
>for you to fetch changes up to b80a0dc53df68c6862b8985ecc12856edb080248:
>
>  ARM: msm: fix compilation error in gpiomux (2013-08-07 10:39:31 -0700)

Sigh, it looks like this fixes code that was removed in last-week's
fix patches.  I can either regenerate the pull request, or feel free
to "resolve" this by just using the removal of the code.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
