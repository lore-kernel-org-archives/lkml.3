Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3IEQyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:54:43 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47478 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3IEQyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:54:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130905150527.GA21185@kroah.com>
References: <20130902235853.GD4544@kroah.com>
	<CAMuHMdXfpMJeTPb4e11_oyqH5TRtTxrUMOnL9GKdSjv3VxDFww@mail.gmail.com>
	<20130905150527.GA21185@kroah.com>
Date: Thu, 5 Sep 2013 18:54:41 +0200
X-Google-Sender-Auth: N3ps17pCIymqiCzUvA_oJjiD4w8
Message-ID: <CAMuHMdVx=Fa9Gw7iDARDRcxNXHNf0+J0FE+LLKup1RSnqijs=g@mail.gmail.com>
Subject: Re: [GIT PATCH] Staging driver patches for 3.12-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, Andrew Morton <akpm@linux-foundation.org>,
        Linux-Next <linux-next@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 5:05 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Sep 05, 2013 at 04:09:48PM +0200, Geert Uytterhoeven wrote:
>> On Tue, Sep 3, 2013 at 1:58 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > Here's the bit staging tree pull request for 3.12-rc1.
>> >
>> > Lots of staging driver updates, and fixes.  Lustre is finally enabled in
>> > the build, and lots of cleanup started happening in it.  There's a new
>>
>> Lustre fails modpost on (at least) 4 architectures due to unexported arch
>> support functions: m68k, mips, parisc and sparc64 (patches sent).
>
> Odd, what functions were not present in those arches that lustre uses
> that no other kernel code uses?

All architectures provided copy_from_user_page() for builtin code, but
somed lacked symbol exports.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
