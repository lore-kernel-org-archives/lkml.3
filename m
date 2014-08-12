Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaHLMub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:50:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbaHLMua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:50:30 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>, Akhil.Bhansali@hgst.com
Subject: Re: [patch] skd: add build dependency on HARDIRQ
References: <x49a97apxf6.fsf@segfault.boston.devel.redhat.com>
	<CAMuHMdWRsxFt+J0JufFtbUGFJeCncD99K6J538QJzhrxfHPXrg@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 12 Aug 2014 08:50:19 -0400
In-Reply-To: <CAMuHMdWRsxFt+J0JufFtbUGFJeCncD99K6J538QJzhrxfHPXrg@mail.gmail.com>
	(Geert Uytterhoeven's message of "Tue, 12 Aug 2014 11:20:56 +0200")
Message-ID: <x49lhqt6fec.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

Hi, Geer,

> Which kernel version does this apply to?
>
> GENERIC_HARDIRQS was removed in
> commit 0244ad004a54e39308d495fee0a2e637f8b5c317
> Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Date:   Fri Aug 30 09:39:53 2013 +0200
>
>     Remove GENERIC_HARDIRQ config option
>
>     After the last architecture switched to generic hard irqs the config
>     options HAVE_GENERIC_HARDIRQS & GENERIC_HARDIRQS and the related code
>     for !CONFIG_GENERIC_HARDIRQS can be removed.
>
>     Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
>
> after it became supported by all architectures.

Ah, thanks for pointing that out.  I needed the patch on an older (3.10
based) kernel and didn't realize it wasn't needed any more.  Sorry for
the noise!

Cheers,
Jeff
