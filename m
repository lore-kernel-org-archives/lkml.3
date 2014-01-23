Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaAWT31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:29:27 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:38800 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaAWT3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:29:24 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1401231417320.7971@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<CA+55aFykzCSKeXgBEiFTozVqbBvJUiK2bdTDfRO80sqZZS8TXw@mail.gmail.com>
	<alpine.LRH.2.02.1401231417320.7971@file01.intranet.prod.int.rdu2.redhat.com>
Date: Thu, 23 Jan 2014 11:29:23 -0800
X-Google-Sender-Auth: 3AzPqHoct3YRYsjiGQRFb-Wzch4
Message-ID: <CA+55aFw1AVYtin48_jpEueo2ESqDav6NZ_f15uaZOPVcufC5Vg@mail.gmail.com>
Subject: Re: [PATCH 0/10] framebuffer patches
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 11:26 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> I posted the patches a year ago to the linux-fbdev mailing list
> (http://marc.info/?l=linux-fbdev&r=6&b=201208&w=2) and to Florian Tobias
> Schandinat who was FB maintainer at that time. I didn't get an answer and
> they were ignored.

Yes, there was a time when fbdev maintainership had responsiveness
issues, but that should be fixed. So I'd much rather have these go
through the channels.

And btw, you actually have access to a TGA card? Trippy.

            Linus
