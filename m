Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762117Ab3DCMbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:31:50 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:35236 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759574Ab3DCMbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:31:49 -0400
MIME-Version: 1.0
In-Reply-To: <1364487492.10838.1.camel@phoenix>
References: <1364487492.10838.1.camel@phoenix>
Date: Wed, 3 Apr 2013 14:31:48 +0200
Message-ID: <CACRpkdaQ2x+i8V8tLVW-zP0+eNWrN28321j0D0E+TcdbG+qoRg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: coh901: Fix error checking in u300_gpio_to_irq
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 5:18 PM, Axel Lin <axel.lin@ingics.com> wrote:

> The pointer "port" is always not NULL if gpio->port_list is not empty.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Excellent catch Axel, thanks!!

Patch applied.

Yours,
Linus Walleij
