Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaGINPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:15:08 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:39442 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaGINPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:15:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Himangi Saraogi <himangi774@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] sh-pfc: sh73a0: Introduce the use of devm_regulator_register
Date: Wed, 09 Jul 2014 15:16:08 +0200
Message-ID: <6084416.kjNb0aQC9P@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACRpkdbX_mhwOP1S6vLxRi8sqvwk4uo+gLk_0a+2wZOjA_Yoig@mail.gmail.com>
References: <20140707160916.GA9238@himangi-Dell> <CACRpkdbX_mhwOP1S6vLxRi8sqvwk4uo+gLk_0a+2wZOjA_Yoig@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014 12:32:44 Linus Walleij wrote:
> On Mon, Jul 7, 2014 at 6:09 PM, Himangi Saraogi wrote:
> > This patch moves data allocated using regulator_register to
> > devm_regulator_register and does away the calls to regulator_unregister.
> > The sh73a0_pinmux_soc_exit function is no longer needed and is removed.
> > 
> > Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> > Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> 
> Laurent is maintaining this driver so let's see if he can ACK it.

Assuming we're talking about https://lkml.org/lkml/2014/7/7/386,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

