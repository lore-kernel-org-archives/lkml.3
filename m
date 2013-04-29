Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603Ab3D2Tde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:33:34 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:56327 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759570Ab3D2TCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:53 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwU-bXZ7wn2dOcLNfPMcjDv3Jvqx_LTt7B+-tj4WcP8Mg@mail.gmail.com>
References: <20130429162115.GA6893@kroah.com>
	<CA+55aFz7bESS-T2_5vndVEzbk7ocmfEanBO+sviTSNekOLKRcg@mail.gmail.com>
	<20130429183851.GA8106@kroah.com>
	<CA+55aFwU-bXZ7wn2dOcLNfPMcjDv3Jvqx_LTt7B+-tj4WcP8Mg@mail.gmail.com>
Date: Mon, 29 Apr 2013 12:02:53 -0700
X-Google-Sender-Auth: yemGt3QPzEADUcC_pzwJOaYEX_4
Message-ID: <CA+55aFw8P1tA+_nyAi2LM7hQ95VB=-CUPGWsps8bVrqC1_XvYw@mail.gmail.com>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Brown <davidb@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 11:55 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But right now it smells like somethign that should not be at
> the top level.

Btw, I pulled and pushed out, because I don't think this is the end of
the world, but it's part of my constant fight against people who think
that *their* subsystem is oh-so-magically important that it needs to
show up as "default y" or otherwise be shown as the center of the
universe. But for everybody else, it makes things like autocomplete
much harder when there are tons of random subdirectories in central
places.

              Linus
