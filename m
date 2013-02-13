Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab3BMNge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:36:34 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40142 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab3BMNgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:36:32 -0500
MIME-Version: 1.0
In-Reply-To: <1360645032-9668-1-git-send-email-s-anna@ti.com>
References: <1360645032-9668-1-git-send-email-s-anna@ti.com>
Date: Wed, 13 Feb 2013 14:36:32 +0100
Message-ID: <CACRpkdZayg-X11ZRnh2Z0i+egBn8Fhwya-6_Yr8wcv+6s0CVqQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] drivers: mailbox: framework creation
From: Linus Walleij <linus.walleij@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Greg Kroah-Hartman <greg@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paul Walmsley <paul@pwsan.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, Omar Ramirez Luna <omar.luna@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 5:56 AM, Suman Anna <s-anna@ti.com> wrote:

> I have hosted the series at [3].
> [3] https://github.com/sumananna/mailbox/commits/dbx500-prcmu-mailbox

Suman, I suggest you ask Stepgen Rothwell to include this
branch into the linux-next tree, so we can get some
rotation of this stuff in preparation for the v3.10 merge
window. (It's not going in now anyway.)

If it proves to survive some smoke testing there, I suggest
we proceed to pull this into the ARM SoC tree early in
the v3.10 kernel cycle, since all the dependencies will be
in ARM SoC anyway.

Yours,
Linus Walleij
