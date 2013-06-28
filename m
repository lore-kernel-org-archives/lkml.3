Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3F1AGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 20:06:14 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:41106 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab3F1AGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 20:06:12 -0400
Date: Thu, 27 Jun 2013 17:06:21 -0700
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Chris Ball <cjb@laptop.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [GIT PULL v2] msm clock for 3.11
Message-ID: <20130628000621.GA11547@quad.lixom.net>
References: <20130614195238.GA2381@codeaurora.org>
 <1372107629-25862-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372107629-25862-1-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 02:00:28PM -0700, David Brown wrote:
> This pull request differs from the previous one for the clock code by:
> 
>   - Gathered additional Acked-by lines.
>   - A small #include fixup found by Stephen Boyd
> 
> The only Ack not received was from Chris Ball, who is CC'd on this
> request.
> 
> The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:
> 
>   Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-clock-for-3.11b

Thanks, pulled into next/late. This conflicts with a fixes-non-critical
fix to removed code, trivially resolved.


-Olof
