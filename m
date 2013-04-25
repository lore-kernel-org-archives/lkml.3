Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab3DYLQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:16:00 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:52209 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab3DYLP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:15:58 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-19-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-19-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:15:58 +0200
Message-ID: <CACRpkdbt0NxDoBa9=Y4eq3FH75pnMT_BkE6Tk-15=H0qnQWaHQ@mail.gmail.com>
Subject: Re: [PATCH 18/32] dmaengine: ste_dma40: Don't configure runtime
 configurable setup during allocate
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:12 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Using the dmaengine API, allocating and configuring a channel are two
> separate actions. Here we're removing logical channel configuration from
> the channel allocating routines.

NAK: this is not true for memcpy.

Yours,
Linus Walleij
