Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab3GPPcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:32:46 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:41818 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab3GPPcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:32:45 -0400
Message-ID: <51E56799.2090601@linaro.org>
Date: Tue, 16 Jul 2013 17:32:41 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Baruch Siach <baruch@tkos.co.il>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 2/2] clocksource/cadence_ttc: Reuse clocksource as
 sched_clock
References: <1373302298-27957-1-git-send-email-soren.brinkmann@xilinx.com> <1373302298-27957-3-git-send-email-soren.brinkmann@xilinx.com> <51DFF1AA.8080407@monstr.eu>
In-Reply-To: <51DFF1AA.8080407@monstr.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 02:08 PM, Michal Simek wrote:
> Acked-by: Michal Simek <monstr@monstr.eu>

Applied to my tree for 3.12

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

