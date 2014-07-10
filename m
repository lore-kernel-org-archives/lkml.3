Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaGJOfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:35:36 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:57608 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaGJOfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:35:34 -0400
MIME-Version: 1.0
In-Reply-To: <1404992799-3705-15-git-send-email-wsa@the-dreams.de>
References: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
	<1404992799-3705-15-git-send-email-wsa@the-dreams.de>
Date: Thu, 10 Jul 2014 16:35:33 +0200
Message-ID: <CACRpkdZ-ZhQQz2-gvSDH-XYCcL-cL5fZKCEw9jeEpDUVRpazng@mail.gmail.com>
Subject: Re: [PATCH 14/16] i2c: i2c-stu300: Drop class based scanning to
 improve bootup time
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 1:46 PM, Wolfram Sang <wsa@the-dreams.de> wrote:

> This driver has been flagged to drop class based instantiation. The removal
> improves boot-up time and is unneeded for embedded controllers. Users have been
> warned to switch for some time now, so we can actually do the removal. Keep the
> DEPRECATED flag, so the core can inform users that the behaviour finally
> changed now. After another transition period, this flag can go, too.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
