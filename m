Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaLNXGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 18:06:23 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:57489 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaLNXGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 18:06:09 -0500
MIME-Version: 1.0
In-Reply-To: <20141214223523.GA3802@kroah.com>
References: <20141214223523.GA3802@kroah.com>
Date: Sun, 14 Dec 2014 15:06:07 -0800
X-Google-Sender-Auth: sTx_bJVVWu1dWvm_PDAyqtU0Ru0
Message-ID: <CA+55aFx4V9urJ=_Ai0-zuQmQvzpz-t250bgDZBEDhWUbfe3oBQ@mail.gmail.com>
Subject: Re: [GIT PULL] USB driver patches for 3.19-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 2:35 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> Hans de Goede (1):
>       uas: Make uas work with blk-mq

So I got some fairly trivial conflicts on this one (conflicting with
the scsi cleanups mainly by Christoph Hellwig.

I resolved the conflict easily, and it all *looks* fine, but quite
frankly, I'd be a lot happier about it if somebody who has the
hardware were to actually test the end result.   The whole interaction
with ".use_blk_tags" etc should be verified by somebody who knows the
code.

Hans? Christoph?

                      Linus
