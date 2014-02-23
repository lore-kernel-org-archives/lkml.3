Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbaBWOlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 09:41:50 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:46544 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaBWOls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 09:41:48 -0500
MIME-Version: 1.0
In-Reply-To: <5308BF5A.3040706@suse.de>
References: <20140220235118.191692546@linuxfoundation.org> <20140220235119.236520201@linuxfoundation.org>
 <CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>
 <20140221202127.GA28780@kroah.com> <CAA_UwzLWGUpQghswiAjo2Ppw0tr3voNPPhekGoHiLTX9MDV3fw@mail.gmail.com>
 <5308BF5A.3040706@suse.de>
From: Ray Strode <halfline@gmail.com>
Date: Sun, 23 Feb 2014 09:41:20 -0500
Message-ID: <CAA_UwzLPsYFY3esh-y0CHC89peZUf+ZYcHf1=MxPPaVrNdXHCQ@mail.gmail.com>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs attribute
To: Hannes Reinecke <hare@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        David Herrmann <dh.herrmann@gmail.com>, Werner Fink <werner@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 22, 2014 at 10:16 AM, Hannes Reinecke <hare@suse.de> wrote:
> And of course, checking for "!tty0" is the proper check for serial console.
> Which, of course, means we have to stay with a broken kernel interface for
> ever and ever.
>
> Innovation, here we come.
So just so we're clear:

1) you have every right to try to make s390 work better
2) You have every right to make mistakes in that venture as well (we
all make mistakes after all)
3) You can even unapologetically break userspace and then be snarky about it
4) And, like the above message, you can also ridicule the code using
the kernel interface you broke

Of those things I'd certainly prefer if you stuck to the first two and
skipped the last two.

For bonus points, you could:

5) Reply to Kay, Greg, and David  when they ask questions about the
patch you wrote
6) Offer a follow up patch that acheives your initial objective
without the ensuing breakage
7) Offer any insight you might have on better ways for plymouth to
achieve what it wants to do going forward that would be less
objectionable

--Ray
