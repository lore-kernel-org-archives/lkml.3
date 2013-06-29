Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab3F2Xpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 19:45:39 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:48225 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab3F2Xp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 19:45:27 -0400
MIME-Version: 1.0
In-Reply-To: <1372435836.6153.0.camel@phoenix>
References: <1372435836.6153.0.camel@phoenix>
Date: Sun, 30 Jun 2013 01:45:26 +0200
Message-ID: <CACRpkdaHJ9fQpJVBxtdtk3=3qYjJ-ncE+OM8-R3MgrqJiRzg3A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: st: Remove unnecessary use of of_match_ptr macro
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 6:10 PM, Axel Lin <axel.lin@ingics.com> wrote:

> This is a DT only driver and st_pctl_of_match is always compiled
> in. Hence of_match_ptr is unnecessary.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

This driver is merged in Mark Brown's regmap tree, please
resend it with my ACK and hos name on To:

Yours,
Linus Walleij
