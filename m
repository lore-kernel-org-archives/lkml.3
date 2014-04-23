Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaDWNWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:22:52 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62626 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaDWNWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:22:51 -0400
Date: Wed, 23 Apr 2014 14:22:38 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silvio F <silvio.fricke@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH 1/6] mfd: stmpe: root out static GPIO and IRQ assignments
Message-ID: <20140423132238.GJ640@lee--X1>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
 <1397659455-13638-2-git-send-email-linus.walleij@linaro.org>
 <20140417104925.GM28725@lee--X1>
 <CACRpkdaHQkOMx1NrAWkDd0prc1AqXRs-p69TX9ihoPUhx49oEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaHQkOMx1NrAWkDd0prc1AqXRs-p69TX9ihoPUhx49oEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> The only platform using the STMPE expander now boots from
> >> device tree using all-dynamic GPIO and IRQ number assignments, so
> >> remove the mechanism to pass this from the device tree entirely.
> >>
> >> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >> ---
> >>  drivers/gpio/gpio-stmpe.c | 18 +++++-------------
> >>  drivers/mfd/stmpe.c       |  3 +--
> >>  include/linux/mfd/stmpe.h | 14 --------------
> >>  3 files changed, 6 insertions(+), 29 deletions(-)
> >
> > MFD changes look good to me.
> >
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> >
> > Do you want me to set up and immutable branch between MFD and GPIO?
> 
> That would be perfect. Can you stack up the MFD portions in patches
> 1 thru 4 (given you're happy with the v2 of 3/6) and provide a branch
> to me, please?

How are you planning on sending 3/6?

Can you send it attached to v1 please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
