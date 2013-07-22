Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab3GVVBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:01:45 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:35859 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab3GVVBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:01:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130715101426.4e4301b3@armhf>
References: <20130715101426.4e4301b3@armhf>
Date: Mon, 22 Jul 2013 23:01:43 +0200
Message-ID: <CACRpkdbX50Ho3CabXbi16Fj0BAVekm=--2T93LNfw7d3i+OfFQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-single: fix compile warning when no CONFIG_PM
From: Linus Walleij <linus.walleij@linaro.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 10:14 AM, Jean-Francois Moine <moinejf@free.fr> wrote:

> This warning has been introduced by the commit
>  0f9bc4bcdf4f pinctrl: single: adopt pinctrl sleep mode management
>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

Patch applied with Tony's ACK.

Yours,
Linus Walleij
