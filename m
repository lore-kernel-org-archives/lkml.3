Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab3KUTGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:06:05 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:37976 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab3KUTGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:06:03 -0500
MIME-Version: 1.0
In-Reply-To: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
Date: Thu, 21 Nov 2013 20:06:02 +0100
X-Google-Sender-Auth: 9zV6Y4jtoz8h5vD_aRcKv7efLUI
Message-ID: <CAMuHMdVoGC3+q2UKvogL=BjkXO3k3Dq9+gGF+7CczG-PJcQPxw@mail.gmail.com>
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 6:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Now a new system call kexec_file_load() is implemented which takes
> kernel fd and initrd fd as parameters. Now kernel should be able
> to verify signature of newly loaded kernel.

Only kernel fd and initrd fd?
What about other fds (e.g. device tree, bootinfo)?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
