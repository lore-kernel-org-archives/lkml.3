Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab3DYLoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:44:14 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:54363 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3DYLoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:44:13 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-32-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-32-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:44:12 +0200
Message-ID: <CACRpkdaF3he9X7fd88TrmtNK8g1U4jUEuy6QpKG0Hg8srXWbng@mail.gmail.com>
Subject: Re: [PATCH 31/32] ARM: ux500: Stop passing MMC's platform data for
 Device Tree boots
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:12 PM, Lee Jones <lee.jones@linaro.org> wrote:

> It was required to pass DMA channel configuration information to the
> MMC driver before the new DMA API was in place. Now that it is, and
> is fully compatible with Device Tree we can stop doing that.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Really nice provided the dependencies are in place.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
