Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbaGDT52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:57:28 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:60013 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaGDT51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:57:27 -0400
MIME-Version: 1.0
In-Reply-To: <1404314924-23564-5-git-send-email-lee.jones@linaro.org>
References: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
	<1404314924-23564-5-git-send-email-lee.jones@linaro.org>
Date: Fri, 4 Jul 2014 21:57:26 +0200
Message-ID: <CACRpkdaDzCDh+UbaF_5no5gQSphoJPnjMKUCXRCxq3BvLo9chg@mail.gmail.com>
Subject: Re: [PATCH 04/12] mfd: stmpe: Rid data size incompatibility warn when
 building for 64bit
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 5:28 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Extinguishes:
>
> ../drivers/mfd/stmpe-i2c.c: In function ‘stmpe_i2c_probe’:
> ../drivers/mfd/stmpe-i2c.c:88:13:
>         warning: cast from pointer to integer of different size
>         partnum = (int)of_id->data;
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Not to mention that it uses the enum where the enum is due.
Good patch.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
