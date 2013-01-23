Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3AWKE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:04:26 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61544 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3AWKEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:04:24 -0500
MIME-Version: 1.0
In-Reply-To: <1355404930-5691-9-git-send-email-lee.jones@linaro.org>
References: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
	<1355404930-5691-9-git-send-email-lee.jones@linaro.org>
Date: Wed, 23 Jan 2013 11:04:24 +0100
Message-ID: <CACRpkdbwQAEQxWpXHoEieou5rShcZvsGSddKLaOjwGeG-2o=wg@mail.gmail.com>
Subject: Re: [PATCH 8/8] ARM: ux500: Remove traces of the ios_handler from
 platform code
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 2:22 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Now MMCI on/off functionality is using the regulator framework
> from the MMCI driver, there is no need to keep the ios_handler
> laying around, duplicating functionality. So we're removing it.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to my ux500-cleanups branch.

Yours,
Linus Walleij
