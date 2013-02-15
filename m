Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935931Ab3BOOxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:53:06 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:62210 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935810Ab3BOOxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:53:05 -0500
MIME-Version: 1.0
In-Reply-To: <1360666720-19006-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1360666720-19006-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1360666720-19006-5-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 15 Feb 2013 15:53:03 +0100
Message-ID: <CACRpkdaW+bksgQR+TG1tbvLgaWEFHihfSvz_dUy1PR-5YQssTg@mail.gmail.com>
Subject: Re: [PATCH 4/6] dma: coh901318_lli: set residue only if dma is in progress
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 11:58 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> When status is DMA_SUCCESS the residue should be zero. Otherwise it's a bug.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
