Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaHKIRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:17:25 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:45445 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaHKIRX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:17:23 -0400
MIME-Version: 1.0
In-Reply-To: <1407492475-26283-10-git-send-email-Julia.Lawall@lip6.fr>
References: <1407492475-26283-10-git-send-email-Julia.Lawall@lip6.fr>
Date: Mon, 11 Aug 2014 10:17:22 +0200
Message-ID: <CACRpkdb8+o0BA_3v9acBX0xybbZSK9zBPFCnjUnpbj=QHjmUyA@mail.gmail.com>
Subject: Re: [PATCH 10/14] gpio: delete unneeded test before of_node_put
From: Linus Walleij <linus.walleij@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 12:07 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Of_node_put supports NULL as its argument, so the initial test is not
> necessary.
>
> Suggested by Uwe Kleine-König.

Patch applied.

Yours,
Linus Walleij
