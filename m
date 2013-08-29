Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3H2RfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:35:20 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:44810 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab3H2RfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:35:17 -0400
MIME-Version: 1.0
In-Reply-To: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org>
References: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org>
Date: Thu, 29 Aug 2013 19:35:16 +0200
Message-ID: <CACRpkdZkPZF++MRfNc4-W-cxUCYafdJ+rcCF+2Mk4ntBkwU62g@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: add GPIO support for F71882FG and F71889F
From: Linus Walleij <linus.walleij@linaro.org>
To: Simon Guinot <simon.guinot@sequanux.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 11:50 AM, Simon Guinot
<simon.guinot@sequanux.org> wrote:

> This patch adds support for the GPIOs found on the Fintek super-I/O
> chips F71882FG and F71889F.
>
> A super-I/O is a legacy I/O controller embedded on x86 motherboards. It
> is used to connect the low-bandwidth devices. Among others functions the
> F71882FG/F71889F provides: a parallel port, two serial ports, a keyboard
> controller, an hardware monitoring controller and some GPIO pins.
>
> Note that this super-I/Os are embedded on some Atom-based LaCie NASes.
> The GPIOs are used to control the LEDs and the hard drive power.
>
> Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
> ---
> Changes since v2:
> - Remove useless NULL setters for driver data.

OK we had some discussion on this: there seem to be no alternatives
to port probing, and hacking these board drivers is mighty cool, so
patch applied.

Yours,
Linus Walleij
