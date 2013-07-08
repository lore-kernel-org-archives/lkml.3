Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3GHSPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 14:15:04 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:35076 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3GHSPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 14:15:02 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Kees Cook <keescook@chromium.org>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        artem.bityutskiy@linux.intel.com, Randy Dunlap <rdunlap@infradead.org>,
        shijie8@gmail.com, Arnd Bergmann <arnd@arndb.de>,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: diskonchip: remove unused entries in Kconfig
References: <1373258360-22702-1-git-send-email-michael.opdenacker@free-electrons.com>
	<CAGXu5j+hwA7eT0p9y-ZSnYoYR5A1va9dXONTOGz0W-WT8Nr_Ew@mail.gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Mon, 08 Jul 2013 20:14:53 +0200
In-Reply-To: <CAGXu5j+hwA7eT0p9y-ZSnYoYR5A1va9dXONTOGz0W-WT8Nr_Ew@mail.gmail.com>
	(Kees Cook's message of "Mon, 8 Jul 2013 05:53:42 -0700")
Message-ID: <87hag4gbqa.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Sun, Jul 7, 2013 at 9:39 PM, Michael Opdenacker
> <michael.opdenacker@free-electrons.com> wrote:
>> This patch proposes to remove kernel configuration parameters
>> defined in drivers/mtd/devices/Kconfig, but used nowhere
>> in the makefiles and source code (except in comments).
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>
> This clean up looks good to me.
>
> Acked-by: Kees Cook <keescook@chromium.org>
Yes, a consequence of the beheading in the commit "mtd: doc: remove support for
DoC 2000/2001/2001+", excellent.

Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

-- 
Robert
