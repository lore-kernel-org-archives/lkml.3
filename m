Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab3DCUin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:38:43 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:45362 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab3DCUim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:38:42 -0400
MIME-Version: 1.0
In-Reply-To: <1364908916-29803-4-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
	<1364908916-29803-4-git-send-email-lee.jones@linaro.org>
Date: Wed, 3 Apr 2013 22:38:41 +0200
Message-ID: <CACRpkdar=xD34yaMP2gOfUPkpxOhDymS6zTedKOEW7j2DNHusA@mail.gmail.com>
Subject: Re: [PATCH 4/9] ARM: ux500: Move Snowball's thermal DT node into
 existing PRCMU one
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

On Tue, Apr 2, 2013 at 3:21 PM, Lee Jones <lee.jones@linaro.org> wrote:

> When the thermal DT node was inserted a new PRCMU node was created;
> however, one already exists in the Snowball DTS file. Here we
> amalgamate the two into a single consolidated node.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied.

Thanks,
Linus Walleij
