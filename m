Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3ISJUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:20:24 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36757 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3ISJUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:20:23 -0400
MIME-Version: 1.0
In-Reply-To: <1379412095-7213-1-git-send-email-geert@linux-m68k.org>
References: <1379412095-7213-1-git-send-email-geert@linux-m68k.org>
Date: Thu, 19 Sep 2013 11:20:22 +0200
X-Google-Sender-Auth: 5mj6tjG3qCMb6D2OHWD15evNPRo
Message-ID: <CAMuHMdW8y9_=LXQ1PXjFaPyq-nYTPe+FodE5hQh4P3QSdnP_dg@mail.gmail.com>
Subject: Re: Preliminary kexec support for Linux/m68k
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>, kexec@lists.infradead.org,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 12:01 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> This is a preliminary set of patches to add kexec support for m68k.

>   - [PATCH 1/3] m68k: Add preliminary kexec support
>   - [PATCH 2/3] m68k: Add support to export bootinfo in procfs
>   - [PATCH 3/3] [RFC] m68k: Add System RAM to /proc/iomem
>
> Notes:
>   - The bootinfo is now saved and exported to /proc/bootinfo, so kexec-tools
>     can read it and pass it (possibly after modification) to the new kernel.
>     This is similar to /proc/atags on ARM.

>   - I based [PATCH 3/3] on the PowerPC version, but it's no longer needed as we
>     now get this information from the bootinfo.
>     Does anyone think this is nice to have anyway?

It seems kexec/kdump on ppc don't use /proc/iomem anymore, and only rely on
/proc/device-tree these days?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
