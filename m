Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaGVSOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:14:30 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34990 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaGVSO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:14:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVjaf+vne4vbUPo8EPs0XnQBbNm2ZOXns8fw5pkg9tRSww@mail.gmail.com>
References: <1406004789-9918-1-git-send-email-xerofoify@gmail.com>
	<874my98p6u.fsf@nemi.mork.no>
	<CA+8MBb+fnCNeQtyEqttxbkWx-4N+GUaKCUoCSdn5X9+bDDvTOg@mail.gmail.com>
	<CAPDOMVjaf+vne4vbUPo8EPs0XnQBbNm2ZOXns8fw5pkg9tRSww@mail.gmail.com>
Date: Tue, 22 Jul 2014 20:14:27 +0200
X-Google-Sender-Auth: uTKshn4j9nhpq4MLZ5E-e_ZyNto
Message-ID: <CAAsK9AGtdJiz0xnmfqLBAqxmt=r+WANsmxwB_vQ3O5aKzMW1LQ@mail.gmail.com>
Subject: Re: [PATCH] edac: Remove fixmes in e7xxx_edac.c
From: Levente Kurusa <lkurusa@redhat.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-22 19:40 GMT+02:00 Nick Krause <xerofoify@gmail.com>:
> [...]
>
> Tony,
>
> What is the value of Page shift then ? If you can tell me it would be
> much easier for
> me to fix this.
> Cheers Nick

Nick,

Help is always welcome. However, what you are doing is effectively a
waste of time for you and for the maintainers as well, and hence cannot
be called help. You are writing emails that make absolutely no sense at all.
If you want to help us out, please consider learning three things:

* The language that the kernel is written in: C
* The language that most kernel developers understand: English
* The environment the kernel is (in most cases) written in: UNIX

If you had known these, then:

* ... you would have already known that FIXMEs exist for a reason which is
   not at all simple.

* ... you would have understood that fixing FIXMEs without ANY reasoning and
   asking about it is completely useless and wastes precious maintainer time.

* ... you could have used grep for finding out PAGE_SHIFT and not need to ask
   for it.

Nick. Look, it is good that you are enthusiastic. However, this kind
of 'work' gives
you an undesirable reputation, which is {IF FROM:xerofoify@* THEN TRASH}...

If you really want to help out, I suggest you to find yourself a piece
of hardware from
the store and try to write a driver for it. That way, you will learn
how it all works, and if
you are intelligent enough then you might get a "Kernel Job - Payed"
like you asked us
for them in November.

Until then, please stop trying for FIXMEs. They will not get you a
commit in the kernel
99% of the time.

Hope you understand,

Levente Kurusa
