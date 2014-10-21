Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaJUTxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:53:04 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:58045 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaJUTxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:53:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tzj7hAC9syi6Mqf3Gz1=T5VksQFBsVLiFmiZ6CM5_34vg@mail.gmail.com>
References: <CAPM=9tyZF2S7PJcLyc=KH_NBFXju8UwvMBOF_MocNK8pPVXDYw@mail.gmail.com>
	<20140912112619.50d3b651@www.etchedpixels.co.uk>
	<CAPM=9tzuHQxPYoUZegKzwUoHBvp1UTkmtV3zcBmUxeJUr9qAWA@mail.gmail.com>
	<CA+55aFzqUsdjyE4ZHLyKwCm-SsV4NvFNyy7FTpROTg-J9+kZmg@mail.gmail.com>
	<CAPM=9tzj7hAC9syi6Mqf3Gz1=T5VksQFBsVLiFmiZ6CM5_34vg@mail.gmail.com>
Date: Tue, 21 Oct 2014 12:53:00 -0700
X-Google-Sender-Auth: tLTEaLH8_lHXi0PdVbjUVgvYpMU
Message-ID: <CA+55aFwidVm7yp8JfketFULDfH5djdKWHZ1CVZ=xWc59mponsw@mail.gmail.com>
Subject: Re: vga and 64-bit memcpy's
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 9:30 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> was tested and found to work, just a question if we care enough to fix
> it I suppose.

Well, we might not care deeply, but at the same time I also do think
that we don't care deeply about the alleged performance advantages of
having that special scr_memmovew() hack.

So I think I'd apply a real (and tested) patch to just remove the
special VT_BUF_HAVE_MEM{CPY|MOVE}W if I got one.

                    Linus
