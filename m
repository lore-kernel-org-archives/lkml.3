Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaHMM7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:59:54 -0400
Received: from purkki.adurom.net ([80.68.90.206]:54028 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaHMM7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:59:52 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Simon Kelley <simon@thekelleys.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] drivers/net/wireless: Remove typedef local_info_t
References: <20140813091713.GA2995@himangi-Dell>
Date: Wed, 13 Aug 2014 15:59:49 +0300
In-Reply-To: <20140813091713.GA2995@himangi-Dell> (Himangi Saraogi's message
	of "Wed, 13 Aug 2014 14:47:13 +0530")
Message-ID: <87egwka6ka.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Himangi Saraogi <himangi774@gmail.com> writes:

> The Linux kernel coding style guidelines suggest not using typedefs
> for structure types. This patch gets rid of the typedef for
> local_info_t. Also, the name of the struct is changed to drop the _t,
> to make the name look less typedef-like.

[...]

>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  drivers/net/wireless/atmel_cs.c | 22 +++++++++++-----------

You should prefix the patch with "atmel_cs:", not
"drivers/net/wireless".

-- 
Kalle Valo
