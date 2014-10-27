Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaJ0QDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:03:24 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:60833 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaJ0QDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:03:22 -0400
MIME-Version: 1.0
In-Reply-To: <1412871518-11359-1-git-send-email-linux@roeck-us.net>
References: <1412871518-11359-1-git-send-email-linux@roeck-us.net>
Date: Mon, 27 Oct 2014 17:03:21 +0100
Message-ID: <CACRpkda=EBPS7Xb5je+eZ2mPqV1xbEAKbaSEcM5BbAX3iCLYSQ@mail.gmail.com>
Subject: Re: [PATCH] mfd: ab8500-sysctrl: Drop ab8500_restart
From: Linus Walleij <linus.walleij@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 6:18 PM, Guenter Roeck <linux@roeck-us.net> wrote:

> ab8500_restart is not called from anywhere in the kernel, so drop it.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Yeah I guess... cannot argue with that.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
