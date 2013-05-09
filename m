Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab3EIRIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 13:08:16 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:45475 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3EIRIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 13:08:15 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6uCJde0vw=zcqJOxdiwOJO8bRe00yzs6UDzup5z-jTRbw@mail.gmail.com>
References: <CACxGe6uCJde0vw=zcqJOxdiwOJO8bRe00yzs6UDzup5z-jTRbw@mail.gmail.com>
Date: Thu, 9 May 2013 10:08:14 -0700
X-Google-Sender-Auth: Ku7yTgp48jnq51-4lIuPvy_1z-I
Message-ID: <CA+55aFwU3w2jiA26fCmF3_i+vpf8TMY+8L5=Oso_uMhZX30DQw@mail.gmail.com>
Subject: Re: [git pull] GENERIC_GPIO removal
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 6:48 AM, Grant Likely <grant.likely@linaro.org> wrote:
>
> * "git grep '\bGENERIC_GPIO\b'" should return 1 hit in the Chinese
>   documentation.

That's the oddest command line I've seen in some time.

You do realize that "git grep" is perfectly happy to just take the
"-w" flag exactly like normal grep?

               Linus
