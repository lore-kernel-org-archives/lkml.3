Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaCTHym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 03:54:42 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:62243 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaCTHyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 03:54:40 -0400
MIME-Version: 1.0
In-Reply-To: <6636992.81rGEKjTqL@vostro.rjw.lan>
References: <1395087971-31897-1-git-send-email-geert@linux-m68k.org>
	<6636992.81rGEKjTqL@vostro.rjw.lan>
Date: Thu, 20 Mar 2014 08:54:39 +0100
X-Google-Sender-Auth: Ot_vWzfTYQUe12ro3xByAsQgew0
Message-ID: <CAMuHMdVZ6VS3zfZ0Li6MEd7tkTdxfRz96L74z0GsfXvxj+cDVA@mail.gmail.com>
Subject: Re: [PATCH 1/2] PM: Correct whitespace errors in <linux/pm.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Wed, Mar 19, 2014 at 11:50 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Monday, March 17, 2014 09:26:10 PM Geert Uytterhoeven wrote:
>> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>
> Why exactly are they errors?

checkpatch.pl says: "WARNING: please, no space before tabs",
Vim (with "let c_space_errors=1") shows them in red.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
