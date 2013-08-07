Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab3HGUoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:44:16 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:57508 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933014Ab3HGUoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:44:15 -0400
Date: Wed, 7 Aug 2013 22:43:38 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linus.walleij@linaro.org
Cc: ciminaghi@gnudd.com, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, x86@kernel.org, hpa@zytor.com,
        mingo@redhat.com, linux@arm.linux.org.uk, tglx@linutronix.de,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 26/26] pinctrl: add support for sta2x11 (via
 pinctrl-nomadik)
Message-ID: <20130807204338.GA14868@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <CACRpkdbSYzQn2U6yijnrNQ0QhnzhUmQz1W=C8NHGhsK6VzRFpA@mail.gmail.com>
References: <CACRpkdbSYzQn2U6yijnrNQ0QhnzhUmQz1W=C8NHGhsK6VzRFpA@mail.gmail.com>
  <cover.1375867291.git.rubini@gnudd.com>
  <b719237403781b77732bb59078ca6f1eb3d76639.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe you could add a commit message?

Ack (Davide is holidays, I grant that for him).

> Apart from that it looks like a straight-forward plug-in to the
> Nomadik pin controller, so I'd happily apply it, but I guess it
> will go in through the x86 tree?

It's part of a bigger series, that adds devicetree support first.
Yes, it's expected to go through a different path, if the whole
series is ok.
 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks for this and the gpio acked-by -- yes, I didn't notice it's a
nomadik logic block; it's Davide who tried to match the registers.

/alessandro
