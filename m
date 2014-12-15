Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaLOSX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:23:58 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:43476 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaLOSXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:23:55 -0500
MIME-Version: 1.0
In-Reply-To: <548EC6C3.9060902@redhat.com>
References: <20141214223523.GA3802@kroah.com>
	<CA+55aFx4V9urJ=_Ai0-zuQmQvzpz-t250bgDZBEDhWUbfe3oBQ@mail.gmail.com>
	<548EC6C3.9060902@redhat.com>
Date: Mon, 15 Dec 2014 10:23:53 -0800
X-Google-Sender-Auth: nsgXr07vh9VL4ylWZQREd44I0lQ
Message-ID: <CA+55aFyNcXXa2wDTqnP6E_DShXgr9nfgG5j-c52PUOPxA6uSiA@mail.gmail.com>
Subject: Re: [GIT PULL] USB driver patches for 3.19-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 3:32 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>
> Code wise this looks good and I've just given:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>
> a spin with an uas disk enclosure, and verified that tcq is being used,
> and everything works fine.

Thanks for verifying,

                  Linus
