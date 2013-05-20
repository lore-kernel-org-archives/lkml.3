Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab3ETUgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:36:16 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:55636 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab3ETUgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:36:15 -0400
MIME-Version: 1.0
In-Reply-To: <1369081324-8062-1-git-send-email-peterhuewe@gmx.de>
References: <1369081324-8062-1-git-send-email-peterhuewe@gmx.de>
Date: Mon, 20 May 2013 22:36:15 +0200
Message-ID: <CACRpkdZvkRh1jEL9rtZMDb1ZBezvYeijFRsJfruQ8igA1+axHQ@mail.gmail.com>
Subject: Re: [PATCH] arm/mach-u300/dummyspichip: Use module_spi_driver to
 register driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 10:22 PM, Peter Huewe <peterhuewe@gmx.de> wrote:

> Removing some boilerplate by using module_spi_driver instead of calling
> register and unregister in the otherwise empty init/exit functions.
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Applied to my U300 branch for v3.11, thanks!

Yours,
Linus Walleij
