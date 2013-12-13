Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3LLUCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:02:07 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8719 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941Ab3LLUCC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:02:02 -0500
Date: Thu, 12 Dec 2013 19:58:46 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 1/2] gpio: msm: Fix irq mask/unmask by writing bits
 instead of numbers
Message-ID: <20131213035845.GK11990@sonymobile.com>
References: <1386717544-478-1-git-send-email-sboyd@codeaurora.org>
 <CACRpkdY8W8tGVH-Os5neeFfHWjojdB5fBbjgWcsWkiMyJj=YAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CACRpkdY8W8tGVH-Os5neeFfHWjojdB5fBbjgWcsWkiMyJj=YAA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12 Dec 11:02 PST 2013, Linus Walleij wrote:

> On Wed, Dec 11, 2013 at 12:19 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> 
> > We should be writing bits here but instead we're writing the
> > numbers that correspond to the bits we want to write. Fix it by
> > wrapping the numbers in the BIT() macro. This fixes gpios acting
> > as interrupts.
> >
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> I've applied this for fixes and tagged for stable.
> Björn, Rohit: OK?

This looks good.

JFYI; the pinctrl-msm is written with gpio-msm-v2 in mind as well, so replacing
it with pinctrl is on my todo list...

Regards,
Bjorn
