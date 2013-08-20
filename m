Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab3HTJNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:13:46 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:61537 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3HTJNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:13:44 -0400
MIME-Version: 1.0
In-Reply-To: <1376239917-15594-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
	<1376239917-15594-4-git-send-email-Julia.Lawall@lip6.fr>
Date: Tue, 20 Aug 2013 11:13:43 +0200
Message-ID: <CACRpkdbwpjE38=-+JmWAAyqqT4mnp-y6_=fkT1BmmKDXCiXb6w@mail.gmail.com>
Subject: Re: [PATCH 3/16] arch/arm/mach-ux500/cpu-db8500.c: Avoid using
 ARRAY_AND_SIZE(e) as a function argument
From: Linus Walleij <linus.walleij@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 6:51 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
> arity of the called function.

Patch applied.

Yours,
Linus Walleij
