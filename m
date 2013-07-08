Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab3GHMxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:53:44 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44191 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3GHMxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:53:43 -0400
MIME-Version: 1.0
In-Reply-To: <1373258360-22702-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1373258360-22702-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Mon, 8 Jul 2013 05:53:42 -0700
X-Google-Sender-Auth: Yg2ErxTVdN2pm-IAHzHwjkEfioQ
Message-ID: <CAGXu5j+hwA7eT0p9y-ZSnYoYR5A1va9dXONTOGz0W-WT8Nr_Ew@mail.gmail.com>
Subject: Re: [PATCH] mtd: diskonchip: remove unused entries in Kconfig
From: Kees Cook <keescook@chromium.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, artem.bityutskiy@linux.intel.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>, shijie8@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 7, 2013 at 9:39 PM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> This patch proposes to remove kernel configuration parameters
> defined in drivers/mtd/devices/Kconfig, but used nowhere
> in the makefiles and source code (except in comments).
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

This clean up looks good to me.

Acked-by: Kees Cook <keescook@chromium.org>

Thanks,

-Kees

--
Kees Cook
Chrome OS Security
