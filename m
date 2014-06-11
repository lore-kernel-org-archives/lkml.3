Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaFKI4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:56:00 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:57548 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbaFKIzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:55:55 -0400
MIME-Version: 1.0
In-Reply-To: <1402238742.32652.1.camel@phoenix>
References: <1402238742.32652.1.camel@phoenix>
Date: Wed, 11 Jun 2014 10:55:54 +0200
Message-ID: <CACRpkdacMw6Uhd-xPp0W_Rgbt4ZnMPhGTzSi+yuO2ooXcaWrxw@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: ab8500: Remove ab8500_regulator_of_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2014 at 4:45 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Now this is a DT-only driver because non-devicetree probe path is removed,
> so merge ab8500_regulator_of_probe() into ab8500_regulator_probe().
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
