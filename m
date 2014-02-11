Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaBKIVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:21:23 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36732 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaBKIVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:21:19 -0500
MIME-Version: 1.0
In-Reply-To: <20140211145606.9e46a881c51e7aa71da43e4c@canb.auug.org.au>
References: <20140211145606.9e46a881c51e7aa71da43e4c@canb.auug.org.au>
Date: Tue, 11 Feb 2014 09:21:18 +0100
Message-ID: <CACRpkdbVABu_BFa==ArUzpeR87QyJBLMmngwC_K7foaX4oUTyw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the pinctrl tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre TORGUE <alexandre.torgue@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 4:56 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> drivers/pinctrl/pinctrl-st.c:407:18: error: 'stid127_delays' undeclared here (not in a function)
>
> Caused by commit cab6bf05bab5 ("pinctrl: st: add stid127 support").

Oh darn, I was waiting for an update of that patch but forgot.

I'll rip out that patch immediately, sorry!

Yours,
Linus Walleij
