Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab3B0RPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:15:14 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61102 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3B0RPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:15:12 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 27 Feb 2013 18:15:11 +0100
Message-ID: <CA+icZUWdumo7-S051gcyZhFY8ARaFQpWASLJLZ4Ai2u_QR-+8A@mail.gmail.com>
Subject: Re: bug in generic strncpy_from_user
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ QUOTE ]
On Wed, Feb 27, 2013 at 3:15 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
>
> Tested with 64 bit kernel with 64 bit and 31 bit mode user space as well as
> with 31 bit kernel and 31 bit user space. Each with legacy and flexible
> mmap layout.
> The bug is fixed and everything else still seems to work. Thanks!
>
> Tested-By: Heiko Carstens <heiko.carstens@de.ibm.com>

Ok, committed.

I'm not marking it for stable, because it doesn't seem to matter all
that much, but if there was some application that actually broke and
made you notice it that way (as opposed to you just noticing the odd
memory map), you might want to inform the stable team about commit
09884964335e.

                    Linus
[ /QUOTE ]

Where is it?

- Sedat -

http://marc.info/?l=linux-kernel&m=136198317320605&w=2
