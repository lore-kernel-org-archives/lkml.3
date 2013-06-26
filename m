Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3FZT7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:59:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54654 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3FZT7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:59:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130626160603.7747e9db0f30c06a243c5aa5@canb.auug.org.au>
References: <20130626160603.7747e9db0f30c06a243c5aa5@canb.auug.org.au>
Date: Wed, 26 Jun 2013 21:59:02 +0200
Message-ID: <CACRpkdYrxdNqLtWvLd09nZD8+-FYCB2EY8tcgTawUSVrUn1HPQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the pinctrl tree with the regmap tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Mark Brown <broonie@kernel.org>, Jingchang Lu <b35083@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 8:06 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Linus,
>
> Today's linux-next merge of the pinctrl tree got a conflict in
> drivers/pinctrl/Makefile between commit 701016c0cba5 ("pinctrl: st: Add
> pinctrl and pinconf support") from the regmap tree and commit
> 78bafc66180d ("pinctrl: add VF610 pinctrl driver") from the pinctrl tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Aha yes Mark is carrying that driver in the regmap tree so should
be expected. Solution is correct, thanks.

Yours,
Linus Walleij
