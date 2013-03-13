Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114Ab3CMSAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:00:05 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:62482 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab3CMSAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:00:03 -0400
MIME-Version: 1.0
In-Reply-To: <1363145044-14442-1-git-send-email-s-anna@ti.com>
References: <1363145044-14442-1-git-send-email-s-anna@ti.com>
Date: Wed, 13 Mar 2013 19:00:02 +0100
Message-ID: <CACRpkdY8ZWNUVHJorbhN7XvOys9KJH8hKeCBYARih=1FiNk-CQ@mail.gmail.com>
Subject: Re: [PATCHv3 03/14] mailbox: OMAP: introduce mailbox framework
From: Linus Walleij <linus.walleij@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 4:24 AM, Suman Anna <s-anna@ti.com> wrote:

> From: Omar Ramirez Luna <omar.luna@linaro.org>
(...)
>
> Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
> [s-anna@ti.com: Kconfig fixes for build errors]
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

It's not like I care super-much, but I think your SoB should
be at the bottom.

It's a simple git rebase -i anyway...

Yours,
Linus Walleij
