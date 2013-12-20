Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3LTJOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:14:42 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58201 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3LTJOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:14:37 -0500
MIME-Version: 1.0
In-Reply-To: <1386941755.17095.2.camel@phoenix>
References: <1386941755.17095.2.camel@phoenix>
Date: Fri, 20 Dec 2013 10:14:36 +0100
Message-ID: <CACRpkdZEagq1xBuj7QCYkA2-961OPseNOQH3upTfASaxUk_ZTg@mail.gmail.com>
Subject: Re: [RFT][PATCH] pinctrl: msm: Fix set gpio setting
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 2:35 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Set g->out_bit bit for gpio output high, clear g->out_bit bit for gpio output
> low.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Bjorn,
> I don't have the datasheet, just found current code does not make sense
> because current code unconditionally set BIT(g->out_bit) in msm_gpio_set.
> I assume setting g->out_bit bit for gpio output high, clear the bit
> for gpio output low.
> Please check if this patch is correct.

I've tentatively applied this as Björn is busy right now, and I got a
sort-of-ack over IRC. If it turns out to be problematic we can revisit
this later.

Yours,
Linus Walleij
