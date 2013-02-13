Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab3BMNn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:43:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42072 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab3BMNn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:43:28 -0500
Date: Wed, 13 Feb 2013 13:42:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Suman Anna <s-anna@ti.com>, Greg Kroah-Hartman <greg@linuxfoundation.org>,
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
Subject: Re: [PATCH v2 00/13] drivers: mailbox: framework creation
Message-ID: <20130213134207.GN17852@n2100.arm.linux.org.uk>
References: <1360645032-9668-1-git-send-email-s-anna@ti.com> <CACRpkdZayg-X11ZRnh2Z0i+egBn8Fhwya-6_Yr8wcv+6s0CVqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZayg-X11ZRnh2Z0i+egBn8Fhwya-6_Yr8wcv+6s0CVqQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 02:36:32PM +0100, Linus Walleij wrote:
> On Tue, Feb 12, 2013 at 5:56 AM, Suman Anna <s-anna@ti.com> wrote:
> 
> > I have hosted the series at [3].
> > [3] https://github.com/sumananna/mailbox/commits/dbx500-prcmu-mailbox
> 
> Suman, I suggest you ask Stepgen Rothwell to include this
> branch into the linux-next tree, so we can get some
> rotation of this stuff in preparation for the v3.10 merge
> window. (It's not going in now anyway.)

Best wait until after v3.9-rc1 - remember that linux-next is supposed to
be a staging tree for the _next_ merge window only.
