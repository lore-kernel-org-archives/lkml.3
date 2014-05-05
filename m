Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaEES0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:26:46 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57594 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaEES0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:26:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [RFC PATCH 0/5] watchdog: Add reboot API
Date: Mon, 5 May 2014 20:26:32 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>, linux-kernel@vger.kernel.org
References: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201405052026.32666.arnd@arndb.de>
X-Provags-ID: V02:K0:9VZn/eLurp15mAr2XUk9BLwwVgMD0L0uiFh/W4sHnR6
 YdU3os6l3Cl+Hl0E09p5YaHgCZOkHXvoSLD1BLVQc5AyB528cq
 fjqEyGnRbRbnJQz/yEYMYCXZatWCQ0J4wztT7F6mIouqZ+bN9p
 aRlnLXf5eu8ey0SoL6dZACEW0YAKYk1pczCYWMdbNh+6eFvGD4
 V/lLwMG2jrG3wVQgPF6EG7sxmSKgF1q2PieejXQOH1NyiKFb9Z
 nlFeJOrMuHcOysX+njD8gm083jKkYa3koDOkKC0Hp6toLgmUaP
 cqRBZ29Xx8UAXIL+FyLUWvnFkD5Yyb6/VtP++Pung0zj1iESu9
 zr5nlMpSJyu5roHZI37w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2014, Guenter Roeck wrote:
> 
> Some hardware implements reboot through its watchdog hardware, for example
> by triggering a watchdog timeout or by writing into its watchdog register
> set. Platform specific code starts to spread into watchdog drivers,
> typically by setting pointers to a callback function which is then called
> from the architecture's reset handler.

Looks very nice to me, thanks for starting this!

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
