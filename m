Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab3FXVC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:02:56 -0400
Received: from void.printf.net ([89.145.121.20]:54705 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab3FXVCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:02:55 -0400
From: Chris Ball <chris@printf.net>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Chris Ball <cjb@laptop.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [GIT PULL v2] msm clock for 3.11
References: <1372107629-25862-1-git-send-email-davidb@codeaurora.org>
Date: Mon, 24 Jun 2013 22:02:17 +0100
In-Reply-To: <1372107629-25862-1-git-send-email-davidb@codeaurora.org> (David
	Brown's message of "Mon, 24 Jun 2013 14:00:28 -0700")
Message-ID: <86fvw76x46.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 24 2013, David Brown wrote:
> This pull request differs from the previous one for the clock code by:
>
>   - Gathered additional Acked-by lines.
>   - A small #include fixup found by Stephen Boyd
>
> The only Ack not received was from Chris Ball, who is CC'd on this
> request.

Sorry about that.  For msm_sdcc.c:

Acked-by: Chris Ball <cjb@laptop.org>

- Chris.
-- 
Chris Ball   <chris@printf.net>   <http://printf.net/>
