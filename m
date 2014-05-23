Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaEWMqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:46:38 -0400
Received: from void.printf.net ([89.145.121.20]:37787 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbaEWMqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:46:36 -0400
From: Chris Ball <chris@printf.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: sdhci-dove: use mmc_of_parse() and remove card_tasklet CD handler
References: <1400797012-32106-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<CAPDyKFoF77fhYVaLX=nSS1A+mi9BUWHszkKA-stcutcOKovMXw@mail.gmail.com>
Date: Fri, 23 May 2014 13:46:31 +0100
In-Reply-To: <CAPDyKFoF77fhYVaLX=nSS1A+mi9BUWHszkKA-stcutcOKovMXw@mail.gmail.com>
	(Ulf Hansson's message of "Fri, 23 May 2014 08:48:00 +0200")
Message-ID: <86k39cr7bs.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 23 2014, Ulf Hansson wrote:
> Thanks Sebastian!
>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>
> Chris, can you pick this up?

Thanks, pushed to mmc-next.

- Chris.
-- 
Chris Ball   <http://printf.net/>
