Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413Ab3B0RUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:20:55 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:42294 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab3B0RUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:20:53 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUWdumo7-S051gcyZhFY8ARaFQpWASLJLZ4Ai2u_QR-+8A@mail.gmail.com>
References: <CA+icZUWdumo7-S051gcyZhFY8ARaFQpWASLJLZ4Ai2u_QR-+8A@mail.gmail.com>
Date: Wed, 27 Feb 2013 09:20:52 -0800
X-Google-Sender-Auth: MjuwA2ACi2QyBgpImrr0QV-NkDA
Message-ID: <CA+55aFzwUj4rc5Lm+--H8pwN-s++4c9X_60O6tQBsE7YZzRw-w@mail.gmail.com>
Subject: Re: bug in generic strncpy_from_user
From: Linus Torvalds <torvalds@linux-foundation.org>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 9:15 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> Where is it?

Oh sorry, I hadn't pushed it out, I was looking through other emails
in the meantime.

Pushed out now (but mirror delays to public sites etc..)

The patch itself is the same one I already attached earlier though
(the last version).

              Linus
