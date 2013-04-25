Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab3DYLfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:35:54 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:49128 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab3DYLfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:35:53 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-26-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-26-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:35:52 +0200
Message-ID: <CACRpkdYR5CeVLprpjMAp2Vo0hQAP1witQd8pa22ek9OzRFe3yQ@mail.gmail.com>
Subject: Re: [PATCH 25/32] ARM: ux500: Setup the DMA40 driver's DT node using
 the new DMA API
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

> The new DMA is now available, so let's use it to setup ST-Ericsson's
> DMA40 driver when Device Tree is enabled.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This is one of those patches I want to put on a special devicetree
branch, but looks allright, Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
