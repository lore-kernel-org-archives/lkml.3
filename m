Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaILKt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:49:57 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:34969 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaILKt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:49:56 -0400
MIME-Version: 1.0
In-Reply-To: <54123EC8.1040906@lwfinger.net>
References: <CAGXu5j+kh3TTR8yiyH35mXUo91g5a-ULS6w2CvKzGmQ4UuL-aA@mail.gmail.com>
	<5412327B.6030000@lwfinger.net>
	<CAGXu5jJmyyWrsS2EFPT59RjK-np3sqmxe69meecmpicv6BNKrA@mail.gmail.com>
	<54123EC8.1040906@lwfinger.net>
Date: Fri, 12 Sep 2014 19:49:50 +0900
Message-ID: <CALLJCT2d8r4ZfKEcY0O-EXBD=wzh0P5qO_tORguTaKxC=4mHUg@mail.gmail.com>
Subject: Re: repeated bugs in new rtl wifi drivers
From: Masanari Iida <standby24x7@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kees Cook <keescook@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry,
One minor note.
There are two typos "Tmis" instead of "This" , "Tme" instead of "The"
in GPLv2 license header within multiple source code of wireless/rtlwifi,
as well as staging/rtl*.

"Tmis program is free software; you can redistribute it and/or modify it"
"Tme full GNU General Public License is included in this distribution in the"

I guess the template file have these typos.

Reported-by: Masanari Iida <standby24x7@gmail.com>

Masanari
