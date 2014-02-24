Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaBXKcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:32:02 -0500
Received: from mail.aswsp.com ([193.34.35.150]:40496 "EHLO mail.aswsp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbaBXKb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:31:59 -0500
Date: Mon, 24 Feb 2014 11:31:53 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
To: Neil Zhang <zhangwm@marvell.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] bug fix for mv_udc_core.c
Message-ID: <20140224113153.64c5a772@parrot.com>
In-Reply-To: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [46.218.109.88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Mon, 24 Feb 2014 16:03:10 +0800,
Neil Zhang <zhangwm@marvell.com> a écrit :

> This patch set is mainly for bug fix.
> 
> Neil Zhang (6):
>   usb: gadget: mv_udc: remove redundant pull up in udc_start
>   usb: gadget: mv_udc: disable HW zlt for ep0
>   usb: gadget: mv_udc: clear corresponding interrupt when flush fifo
>   usb: gadget: mv_udc: check endpoint before queue dtd
>   USB: gadget: mv_udc: workaroud for missing dTD
>   USB: gadget: mv_udc: fix corner case for missiong dTD
> 
>  drivers/usb/gadget/mv_udc_core.c |   47 ++++++++++++++++++++++++++++++++++----
>  1 file changed, 42 insertions(+), 5 deletions(-)
> 

Do you have plan to move to the chipidea udc driver ?

You could have some bug fix for free or share your bug fix with others.


Matthieu
