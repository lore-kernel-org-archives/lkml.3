Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbaEEMiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:38:50 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:59443 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbaEEMit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:38:49 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFz6Sxjy9jdai=TkeB2Rbpu0ydL4-YW4j-S-9oixDu5oZw@mail.gmail.com>
References: <CA+55aFz6Sxjy9jdai=TkeB2Rbpu0ydL4-YW4j-S-9oixDu5oZw@mail.gmail.com>
Date: Mon, 5 May 2014 08:38:48 -0400
X-Google-Sender-Auth: ng4TCswl-5B20zygg-VR9YEgdVk
Message-ID: <CA+5PVA4Wt19ByW5c__jJWFFz0_0uvnbQeRn13w6S43TMZJt8YA@mail.gmail.com>
Subject: Re: Linux 3.15-rc4
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        konstantin@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2014 at 10:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Nothing particularly unusual going on. 45% drivers (drm, sound, md,
> pin-control, acpi etc), 40% arch (mainly powerpc/powernv, but x86 and
> arm too), 15% misc (perf tooling, documentation updates, core code).
> The appended shortlog gives some kind of overview of the details
> without being _too_ big.
>
> There's a few known things pending still (pending fix for some
> interesting dentry list corruption, for example - not that any
> remotely normal use will likely ever hit it), but on the whole things
> are fairly calm and nothing horribly scary. We're in the middle of the
> calming-down period, so that's just how I like it.
>
> But the more testing we get, the better, so please do give this a whirl,

Did the patch-3.15-rc4.xz tarball not get uploaded/created on
kernel.org?  The frontpage doesn't seem to have been updated for -rc4,
and I can't find it here either:

https://www.kernel.org/pub/linux/kernel/v3.x/testing/

josh
