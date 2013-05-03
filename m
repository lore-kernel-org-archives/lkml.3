Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763405Ab3ECT1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:27:49 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:60655 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763076Ab3ECT1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:27:48 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-2-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-2-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 21:27:47 +0200
Message-ID: <CACRpkdacfGZ5tWiKM_RxbaQv+8QQaU1Wq_7TgYHtHTNqr9BqVw@mail.gmail.com>
Subject: Re: [PATCH 01/63] ARM: ux500: Supply address location names for the
 DMA40 DMA controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:31 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The DMA40 controller uses two sets of base addresses. In order to have
> the resources setup by the of_platform framework so they are searchable
> by name instead of index, we have to set names for them. The names have
> to be the same as the ones used to fetch them back out of the resource
> structure.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied this one to my ux500-devicetree branch.

Thanks,
Linus Walleij
