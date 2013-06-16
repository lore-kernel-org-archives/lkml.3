Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3FPKTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 06:19:35 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:45337 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab3FPKTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 06:19:33 -0400
MIME-Version: 1.0
In-Reply-To: <1371198288-23829-1-git-send-email-christian.ruppert@abilis.com>
References: <51BAC3A1.80105@st.com>
	<1371198288-23829-1-git-send-email-christian.ruppert@abilis.com>
Date: Sun, 16 Jun 2013 12:19:33 +0200
Message-ID: <CACRpkdY2t0jeRYmUAwvvGYoyrGrtU00_P76=cL0w0egRnLtO6Q@mail.gmail.com>
Subject: Re: [PATCH] Fix comment on pinctrl_gpio_range.pin_base
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Patrice CHOTARD <patrice.chotard@st.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 10:24 AM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

> The comment introduced with the recently added pinctrl_gpio_range.pins
> element was wrong. This corrects it.
> Thanks to Patrice Chotard for pointing this out.
>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>

Patch applied.

Yours,
Linus Walleij
