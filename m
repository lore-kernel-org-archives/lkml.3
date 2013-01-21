Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab3AUMWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:22:17 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:47544 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3AUMWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:22:16 -0500
Date: Mon, 21 Jan 2013 13:22:03 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] clocksource: dbx500-prcmu: use relaxed readl variant
Message-ID: <20130121122203.GA30289@balto.lan>
References: <1358770172-30125-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358770172-30125-1-git-send-email-fabio.baltieri@linaro.org>
X-Operating-System: Linux balto 3.8.0-rc3-00293-g406089d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 01:09:31PM +0100, Fabio Baltieri wrote:
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> 
> Modify clksrc_dbx500_prcmu_read to replace readl() with readl_relaxed().
> This speeds up calls to the function by about 40%.

Hello John,

these two patches may go in the existing ux500 clksrc branch
together with the nomadik-mtu's patches queued up some time ago.

Can I have your Acked-by for that?

Thanks,
Fabio

-- 
Fabio Baltieri
