Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3A1KRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:17:50 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:38712 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3A1KRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:17:48 -0500
MIME-Version: 1.0
In-Reply-To: <1359133168-14879-3-git-send-email-gregory.clement@free-electrons.com>
References: <1359133168-14879-1-git-send-email-gregory.clement@free-electrons.com>
	<1359133168-14879-3-git-send-email-gregory.clement@free-electrons.com>
Date: Mon, 28 Jan 2013 11:17:48 +0100
Message-ID: <CACRpkdaEH+hqOo6i+4Lz+T4B+oAvCj+v0Ycr576yV2fWN2VNvg@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: pca953x: use managed resources
From: Linus Walleij <linus.walleij@linaro.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 5:59 PM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> Using the devm_* managed resources the pca driver can be simplified
> and cut down on boilerplate code.
>
> [gcl: fixed a inccorect reference to a removed label, "goto fail_out"
> became "return ret"]

Oh now "gcl" means both Grant C. Likely and Gregory CLement :-)

> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Patch applied, thanks!

Yours,
Linus Walleij
