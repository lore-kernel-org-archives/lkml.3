Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935452Ab3BOJMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 04:12:42 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:33805 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab3BOJMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 04:12:39 -0500
MIME-Version: 1.0
In-Reply-To: <1360849767-1463135-7-git-send-email-arnd@arndb.de>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
	<1360849767-1463135-7-git-send-email-arnd@arndb.de>
Date: Fri, 15 Feb 2013 10:12:39 +0100
Message-ID: <CACRpkdacWrY=Bb-1e+eicFYD3bQCkPjFbcX==sy_aSNa25g8BA@mail.gmail.com>
Subject: Re: [PATCH 06/11] ARM: integrator/versatile: fix NOMMU warnings
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 2:49 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> On NOMMU kernels, the io_desc variables are unused
> because we don't use the MMU to remap the MMIO
> areas.
>
> Marking these variables as __maybe_unused easily
> avoids the otherwise harmless warnings like
>
> warning: 'versatile_io_desc' defined but not used
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
