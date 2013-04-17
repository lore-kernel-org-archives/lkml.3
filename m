Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966856Ab3DQVbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 17:31:17 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37240 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965687Ab3DQVbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 17:31:14 -0400
MIME-Version: 1.0
In-Reply-To: <201304172328.01071.arnd@arndb.de>
References: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
	<201304171115.51509.arnd@arndb.de>
	<CA+55aFxuLZ5Y2qLtn5=MXNF7oiuTK3ZuQhAjWPPb1wrd6D7sZw@mail.gmail.com>
	<201304172328.01071.arnd@arndb.de>
Date: Wed, 17 Apr 2013 14:31:13 -0700
X-Google-Sender-Auth: GbDt2dYvKA3_3oCXaSK_-FjYcGM
Message-ID: <CA+55aFwTG6VhjimtaROxPNBWFukq7yW7B1g+tTU1L04U9OTPdg@mail.gmail.com>
Subject: Re: Device driver memory 'mmap()' function helper cleanup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 2:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> There is a separate check for the physical address that gets
> mapped in hpet_mmap:

Ahh, right you are. The earlier check for PAGE_SIZE's mapping and zero
offset is indeed superfluous.

         Linus
