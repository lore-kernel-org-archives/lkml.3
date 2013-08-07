Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab3HGTfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:35:05 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55254 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab3HGTfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:35:02 -0400
MIME-Version: 1.0
In-Reply-To: <000201ce9285$2592b3c0$70b81b40$@samsung.com>
References: <000201ce9285$2592b3c0$70b81b40$@samsung.com>
Date: Wed, 7 Aug 2013 21:35:02 +0200
Message-ID: <CACRpkdb4g5XK16B3TUoTO6mo-fviiEKsm=5SXufrpVeibCXTfw@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: st: Staticize local symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 11:12 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> These local symbols are used only in this file.
> Fix the following sparse warning:
>
> drivers/pinctrl/pinctrl-st.c:291:14: warning: symbol 'stih415_input_delays' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-st.c:292:14: warning: symbol 'stih415_output_delays' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-st.c:327:14: warning: symbol 'stih416_delays' was not declared. Should it be static?
> drivers/pinctrl/pinctrl-st.c:814:12: warning: symbol 'st_pmx_get_fname' was not declared. Should it be static?
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

I already got an identical patch by some other sparse hacker, but thanks
anyway!

Yours,
Linus Walleij
