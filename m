Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935881Ab3BOOwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:52:13 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:60491 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935801Ab3BOOwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:52:11 -0500
MIME-Version: 1.0
In-Reply-To: <1360666720-19006-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1360666720-19006-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1360666720-19006-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 15 Feb 2013 15:52:10 +0100
Message-ID: <CACRpkdZ=9pmutR2G+z5kQpjx2O6995OnDU8iN3cqar3TWoX=Lg@mail.gmail.com>
Subject: Re: [PATCH 3/6] dma: coh901318_lli: avoid unbalanced locking
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

> I have not checked the code but there is a possibility that custom pool->lock
> is not needed at all due to dma_pool contains it's own lock.

Can you please change the description to something like:

"The coh901318_lli allocator releases a lock on the exit path without
taking it first".

Which is what the patch is actually fixing.

After that it's Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
