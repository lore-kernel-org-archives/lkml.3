Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaD1J0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:26:46 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:65226 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbaD1J0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:26:01 -0400
Date: Mon, 28 Apr 2014 10:25:55 +0100
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
Message-ID: <20140428092555.GL6264@lee--X1>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
 <1397659455-13638-2-git-send-email-linus.walleij@linaro.org>
 <20140417104925.GM28725@lee--X1>
 <CACRpkdaHQkOMx1NrAWkDd0prc1AqXRs-p69TX9ihoPUhx49oEQ@mail.gmail.com>
 <20140423132238.GJ640@lee--X1>
 <CACRpkdaHFGNaddteKYKz+zzYuhRXnAyzHzJ-cfx1h9mB-YWzew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaHFGNaddteKYKz+zzYuhRXnAyzHzJ-cfx1h9mB-YWzew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> That would be perfect. Can you stack up the MFD portions in patches
> >> 1 thru 4 (given you're happy with the v2 of 3/6) and provide a branch
> >> to me, please?
> >
> > How are you planning on sending 3/6?
> 
> Hum, I just sent it ... by mail...
> http://marc.info/?l=linux-kernel&m=139825313606633&w=2
> 
> > Can you send it attached to v1 please?
> 
> Do you mean you want me to repost the entire series?

No, just a single patch posted as a reply to v1. However, it appears
that you already sent out the next version, which I'll take a look at
now.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
