Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762831Ab3DCUc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:32:29 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:57251 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760603Ab3DCUc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:32:28 -0400
MIME-Version: 1.0
In-Reply-To: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
Date: Wed, 3 Apr 2013 22:32:27 +0200
Message-ID: <CACRpkdbgFjvZkOAJd5g335DnHWdAQJgOg3EVUL88+bkS41eq9g@mail.gmail.com>
Subject: Re: [PATCH 1/9] ARM: ux500: Increase the size of the PRCMU's TCPM size
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 3:21 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The Tightly Coupled Program Memory location is actually 32kB in
> size, rather than the originally depicted 4kB.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied.

Yours,
Linus Walleij
