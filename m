Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749Ab3ECQ4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:56:12 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:58662 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab3ECQ4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:56:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130503185148.600554bd@endymion.delvare>
References: <CACxGe6vr1kh2yqnG6kpASBGDUQrC7taBu00VWu6VG+qCO2u9QA@mail.gmail.com>
	<CA+55aFw9fbZBiZDC25j4A50NmsYbpwV-wUfWMpE_D7bEXQ-XVg@mail.gmail.com>
	<20130503185148.600554bd@endymion.delvare>
Date: Fri, 3 May 2013 09:56:09 -0700
X-Google-Sender-Auth: jMcpAqzrrOlKCRrKgxELry7Jy0c
Message-ID: <CA+55aFx4Q6tSidW2sihZSjNyRYJLftT=s8QKpx6bCe_4M0hwug@mail.gmail.com>
Subject: Re: [git pull] GPIO for v3.10
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <samuel@sortiz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 9:51 AM, Jean Delvare <khali@linux-fr.org> wrote:
>
> The real problem here is that two patches which depended on each other
> went to you through 2 different maintainer trees (mfd maintained by
> Samuel Ortiz and gpio maintained by Grant L. & Linus W.), and the git
> pull requests reached you in the wrong order. That doesn't make us all
> irresponsible and lame contributors/maintainers, does it?

F*ck yes it does.

It means that NOBODY EVEN TEST-COMPILED THE TREE THAT GOT SENT TO ME.

WTF?

If that's not "irresponsible and lame", I don't know what the hell is.

                      Linus
