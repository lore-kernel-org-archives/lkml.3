Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab3HUVt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:49:59 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:44568 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3HUVt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:49:58 -0400
MIME-Version: 1.0
In-Reply-To: <1375610330-18185-6-git-send-email-maxime.ripard@free-electrons.com>
References: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
	<1375610330-18185-6-git-send-email-maxime.ripard@free-electrons.com>
Date: Wed, 21 Aug 2013 23:49:58 +0200
Message-ID: <CACRpkdb0-Ue3aRT8ohHVMUU3RmeL4D0ZDR6pB-OBb0p+2Anw9Q@mail.gmail.com>
Subject: Re: [PATCHv3 5/9] pinctrl: sunxi: Fix inconsistent indentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 4, 2013 at 11:58 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> Some pin functions in the array were not indented like the other
> functions in this array. Fix this.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Patch applied.

Since the reply mentions that you want me to apply it I
did so.

And I assume you want to take the two others so I
applied those as well.

The thing that made it take time was partly that it
was part of a multi-patch set and I couldn't figure out
how that was going to be merged and as there were
comments on the other patches in the set I assume
the whole thing will be respun.

But whatever, I applied these three patches now,
tell me if there are more of them.

Yours,
Linus Walleij
