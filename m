Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783Ab3ENOQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:16:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46857 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab3ENOQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:16:09 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbbDzudp_W0d1VW1NCMUTHA25v2N3rXopQ+_zGrQB9AyQ@mail.gmail.com>
References: <1368370791-32630-1-git-send-email-laurent.navet@gmail.com>
	<CACRpkdbbDzudp_W0d1VW1NCMUTHA25v2N3rXopQ+_zGrQB9AyQ@mail.gmail.com>
Date: Tue, 14 May 2013 16:16:08 +0200
Message-ID: <CAH7P7NjhjHNfmHbLZ5MfZveY40W8j69mgZ71FVyop=F7WM7_Bg@mail.gmail.com>
Subject: Re: [PATCH] drivers: pinctrl: vt8500: use devm_ioremap_resource()
From: Laurent Navet <laurent.navet@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Tony Prisk <linux@prisktech.co.nz>,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh is that deprecated? I had no clue :-/
> Can you point to some rationale about this so I'm not
> totally misguided in my world..?
>
Yes: https://lkml.org/lkml/2013/1/21/360

>
> Grant is just going to *not* love this type of patches replacing
> nullchecks with IS_ERR() stuff all over the kernel.

again, yes : https://lkml.org/lkml/2013/2/9/52

Laurent,
