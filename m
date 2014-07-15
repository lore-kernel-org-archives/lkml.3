Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbaGONTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:19:51 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:46581 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826AbaGONTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:19:49 -0400
MIME-Version: 1.0
In-Reply-To: <4213.1405430178@warthog.procyon.org.uk>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<4213.1405430178@warthog.procyon.org.uk>
Date: Tue, 15 Jul 2014 15:19:47 +0200
Message-ID: <CAFLxGvw_fnG1KTVXrcZxHZzKPnG5DA117VmcZBvw3EYgXw-DVw@mail.gmail.com>
Subject: Re: [PATCH v2 00/29] nios2 Linux kernel port
From: Richard Weinberger <richard.weinberger@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Ley Foon Tan <lftan@altera.com>, Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>, cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 3:16 PM, David Howells <dhowells@redhat.com> wrote:
> Ley Foon Tan <lftan@altera.com> wrote:
>
>> Nios2 GCC port is in mainline and will be in the FSF 4.9 release.
>
> I managed to build a nios2-linux-gnu cross compiler from gcc-4.9.0 that I can
> add to the Fedora cross-compiler set.  I can't build libgcc without kernel
> headers, though:-/
>

Having it on https://www.kernel.org/pub/tools/crosstool/ would be also nice.

> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,
//richard
