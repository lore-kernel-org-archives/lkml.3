Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762774Ab3DCUdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:33:38 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40563 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762215Ab3DCUdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:33:37 -0400
MIME-Version: 1.0
In-Reply-To: <1364908916-29803-2-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
	<1364908916-29803-2-git-send-email-lee.jones@linaro.org>
Date: Wed, 3 Apr 2013 22:33:36 +0200
Message-ID: <CACRpkdapOBRLAtYOh=CvfqDbxxovn+qO0QiOhGCrYtv2qSt-Ng@mail.gmail.com>
Subject: Re: [PATCH 2/9] ARM: ux500: Remove incorrect DB9540 PRCMU TCDM base location
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

> The Tightly Coupled Data Memory for the DB9540 is actually in the
> same place as the DB8500's. This definition is just plain wrong.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied.

Yours,
Linus Walleij
