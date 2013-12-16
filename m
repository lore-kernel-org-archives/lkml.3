Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab3LPMOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:14:53 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:41286 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab3LPMOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:14:51 -0500
MIME-Version: 1.0
In-Reply-To: <1386931648-1540-1-git-send-email-lee.jones@linaro.org>
References: <1386931648-1540-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 16 Dec 2013 13:14:48 +0100
Message-ID: <CACRpkdZrCU-rVmZy-UBzi1sxfk21xtbwMPT6T7UMj=kZ1q5rxg@mail.gmail.com>
Subject: Re: [PATCH 1/1] usb: musb: ux500_dma: fix potential NULL dereference error
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:47 AM, Lee Jones <lee.jones@linaro.org> wrote:

> static checker warning: "drivers/usb/musb/ux500_dma.c:335
> ux500_dma_controller_start()
>          error: potential NULL dereference 'param_array'."
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
