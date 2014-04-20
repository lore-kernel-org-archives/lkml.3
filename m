Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbaDTTgn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 15:36:43 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:47999 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaDTTgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 15:36:40 -0400
Date: Sun, 20 Apr 2014 12:36:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, linux-input@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RESEND: PATCH 2/2] input: tc3589x-keypad: support probing from
 device tree
Message-ID: <20140420193636.GG12454@core.coreip.homeip.net>
References: <1397028491-15462-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397028491-15462-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 09:28:11AM +0200, Linus Walleij wrote:
> Implement device tree probing for the tc3589x keypad driver.
> This is modeled on the STMPE keypad driver and tested on the
> Ux500 TVK1281618 UIB.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Use two local u32 variables to avoid weirdness in u8 casting
>   of the resulting values to the pointers.
> ChangeLog v1->v2:
> - Fix rows/columns binding to read two u32's insead of two
>   u8 /bits/ as noted by Mark Rutland.

Applied, thank you.

-- 
Dmitry
