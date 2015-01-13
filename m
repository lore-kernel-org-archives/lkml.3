Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbbAMSKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:10:03 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:55994 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbbAMSKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:10:01 -0500
MIME-Version: 1.0
In-Reply-To: <20150113174842.GA2174@p183.telecom.by>
References: <54b431cc.+CIo9/mn2KjN+BdH%akpm@linux-foundation.org>
	<20150113174842.GA2174@p183.telecom.by>
Date: Tue, 13 Jan 2015 19:09:59 +0100
X-Google-Sender-Auth: 8DjrvjsGA6PKbcyf0ih4MnKxJoY
Message-ID: <CAMuHMdVUh4La+YqQzUZfTW9oJYD751WLEKdNL0exZVe2JcdPOg@mail.gmail.com>
Subject: Re: + linux-typesh-always-use-unsigned-long-for-pgoff_t.patch added
 to -mm tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 6:48 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Mon, Jan 12, 2015 at 12:42:52PM -0800, akpm@linux-foundation.org wrote:
>> -#ifndef pgoff_t
>>  #define pgoff_t unsigned long
>> -#endif
>
> Should be typedef'ed.

Note that there's still an ugly define in
drivers/staging/lustre/lustre/include/cl_object.h, which I didn't dare
to touch...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
