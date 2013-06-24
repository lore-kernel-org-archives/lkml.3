Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3FXMjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:39:16 -0400
Received: from gloria.sntech.de ([95.129.55.99]:46228 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab3FXMjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:39:14 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: establish pull-up/pull-down terminology
Date: Mon, 24 Jun 2013 14:39:05 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        James Hogan <james.hogan@imgtec.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
References: <1371379548-6482-1-git-send-email-linus.walleij@stericsson.com> <201306220139.28794.heiko@sntech.de> <CACRpkdYMe+q2GUXooSeVVua3-AHDJFfWQu21bn45b_omsA7FAQ@mail.gmail.com>
In-Reply-To: <CACRpkdYMe+q2GUXooSeVVua3-AHDJFfWQu21bn45b_omsA7FAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306241439.05875.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 24. Juni 2013, 14:24:12 schrieb Linus Walleij:
> On Sat, Jun 22, 2013 at 1:39 AM, Heiko Stübner <heiko@sntech.de> wrote:
> > Am Samstag, 22. Juni 2013, 01:30:18 schrieb Laurent Pinchart:
> >> [Stephen]
> >> 
> >> > IIRC the idea of the PULL_PIN_DEFAULT was to avoid having to specify
> >> > UP/DOWN for each pin/group, but could just say "default", which would
> >> > then reduce the number of pinctrl mapping table entries or pinctrl DT
> >> > property entries.
> >> 
> >> I may be mistaken, but I've understood the PULL_PIN_DEFAULT option as a
> >> way to select the default bias configuration when the default value is
> >> hardware- controlled, not as a pure software option.
> > 
> > Yep that was the original intent ... to handle hardware that hides the
> > complete logic from the software and you only get to turn it on or off,
> > while the direction and other params are determined internally for
> > example by the pin function.
> 
> Heiko, can you send a documentation patch to clarify this so we
> don't get any misunderstandings?
> 
> Maybe it'd be useful for software purposes as well, but let's save
> that for when it gets used like that.

will try to get this (and the changes from the other mail) done today

Heiko
