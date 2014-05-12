Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaELHDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:03:23 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41671 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaELHDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:03:22 -0400
MIME-Version: 1.0
X-Originating-IP: [36.239.230.27]
In-Reply-To: <1399456105.15392.3.camel@AMDC1943>
References: <1399358258-21536-1-git-send-email-k.kozlowski@samsung.com>
	<1399456105.15392.3.camel@AMDC1943>
Date: Mon, 12 May 2014 15:03:21 +0800
Message-ID: <CAFRkauBR=LyfGMPkLd9fut9fCYQD+fhfr+nguaJJfARyOgO4Fw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] regulator: s2mps11: Fix accidental enable of buck6
 ramp delay
From: Axel Lin <axel.lin@ingics.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-07 17:48 GMT+08:00 Krzysztof Kozlowski <k.kozlowski@samsung.com>:
> I forgot to CC the stable.
>
> Mark, if the patches are OK and if you'll apply them, could you add a CC
> stable to the commit msg?

Hi Krzysztof,
Unless this serial misses 3.15, I think this serial does not need to CC stable.

Both
b96244fad953 ("regulator: s2mps11: Don't check enable_shift before
setting enable ramp rate")
f7b1a8dc1c1c ("regulator: s2mpa01: Don't check enable_shift before
setting enable ramp rate")
are exist in 3.15 only.

$ git describe --contains b96244fad953
regulator-v3.15-fixes^3
$ git describe --contains f7b1a8dc1c1c
regulator-v3.15-fixes^3~1

Regards,
Axel
