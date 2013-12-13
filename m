Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3LMThi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:37:38 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:56895 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3LMThh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:37:37 -0500
MIME-Version: 1.0
In-Reply-To: <20131213074428.GA24650@norris-Latitude-E6410>
References: <20131213074428.GA24650@norris-Latitude-E6410>
Date: Fri, 13 Dec 2013 11:37:36 -0800
X-Google-Sender-Auth: R3HiLSGLO8cy-6TyaFPd2n2-0Yc
Message-ID: <CA+55aFxM+fMw5trODzJouaqgewoLy06mxRcdvA5WPTw1=Gk4pw@mail.gmail.com>
Subject: Re: [GIT PULL] MTD fixes for 3.13-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 11:44 PM, Brian Norris
<computersforpeace@gmail.com> wrote:
>
> Here are two MTD fixes for the pxa3xx-nand driver.

Pulled..

I do note that your pgp key still has very few signatures, and none of
them in my normal key ring. Any possibility that you might expand on
your signatures a bit?

(The key is useful even so to show that all the pulls come from the
same person - or at least somebody with access to the key - but it
would be nice to fill out the trust network a bit..)

               Linus
