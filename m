Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935Ab3EBVYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:24:19 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:34661 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3EBVYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:24:18 -0400
MIME-Version: 1.0
In-Reply-To: <51820C2C.1080404@freescale.com>
References: <1366967337-5534-1-git-send-email-b32955@freescale.com>
	<1366967337-5534-6-git-send-email-b32955@freescale.com>
	<20980858CB6D3A4BAE95CA194937D5E73E9BF544@DBDE04.ent.ti.com>
	<5181CC19.8000904@freescale.com>
	<20980858CB6D3A4BAE95CA194937D5E73E9C09FC@DBDE04.ent.ti.com>
	<51820127.5060003@freescale.com>
	<20980858CB6D3A4BAE95CA194937D5E73E9C0A2F@DBDE04.ent.ti.com>
	<51820C2C.1080404@freescale.com>
Date: Thu, 2 May 2013 14:24:17 -0700
Message-ID: <CAN8TOE9P5Op-GK6U10g2b5MGvUQOPAS=5wRY0Hx55riW7OGHiQ@mail.gmail.com>
Subject: Re: [PATCH V4 5/9] mtd: replace the hardcode with the onfi_feature()
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: "Gupta, Pekon" <pekon@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 11:48 PM, Huang Shijie <b32955@freescale.com> wrote:
> 于 2013年05月02日 14:17, Gupta, Pekon 写道:
>
>> [Pekon]: onfi_feature() is actually not useful unless someone re-scans the
>
> I do not think so. :)
>
> I think the onfi_feature() is useful in the future.
> I only add the two feauture for this helper:
>   [1] 16-bit and
>   [2] extended parameter page
>
> But in actually, we may add more feature to this helper, such as
> _synchronous_.
> For example, some driver may support the synchronous mode for the ONFI nand.
> We can use this onfi_feature() in the driver to check if the onfi nand
> supports this
> synchronous feature.
>
> Add this helper makes the code more readable, though we introduce a little
> redandancy.

I agree with the thoughts here. Readability and reusability are
improved a bit by including the ONFI version check.

(BTW, I haven't forgotten this series. I had some distractions here. I
will fully test and provide my Reviewed-by/Tested-by eventually...)

Brian
