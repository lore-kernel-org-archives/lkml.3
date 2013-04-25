Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3DYIpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:45:08 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:58344 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab3DYIpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:45:06 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-11-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-11-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 10:45:04 +0200
Message-ID: <CACRpkdYtS9C1cSV7F62geEjUzvQUaMr_cHTrUhiAGoz9Ly98UA@mail.gmail.com>
Subject: Re: [PATCH 10/32] ARM: ux500: Remove unused 'data_width' attributes
 from SSP DMA configs
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

On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> DMA configuration data is now allocated in the SSP driver, so these
> are just ignored.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
