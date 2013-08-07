Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab3HGTrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:47:20 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:65024 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab3HGTrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:47:18 -0400
MIME-Version: 1.0
In-Reply-To: <b719237403781b77732bb59078ca6f1eb3d76639.1375867291.git.rubini@gnudd.com>
References: <cover.1375867291.git.rubini@gnudd.com>
	<b719237403781b77732bb59078ca6f1eb3d76639.1375867291.git.rubini@gnudd.com>
Date: Wed, 7 Aug 2013 21:47:18 +0200
Message-ID: <CACRpkdbSYzQn2U6yijnrNQ0QhnzhUmQz1W=C8NHGhsK6VzRFpA@mail.gmail.com>
Subject: Re: [PATCH 26/26] pinctrl: add support for sta2x11 (via pinctrl-nomadik)
From: Linus Walleij <linus.walleij@linaro.org>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 12:22 PM, Davide Ciminaghi <ciminaghi@gnudd.com> wrote:

> Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

Maybe you could add a commit message?

Apart from that it looks like a straight-forward plug-in to the
Nomadik pin controller, so I'd happily apply it, but I guess it
will go in through the x86 tree?

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
