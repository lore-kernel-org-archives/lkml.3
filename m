Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbaCQOFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:05:09 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:34850 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbaCQOFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:05:06 -0400
MIME-Version: 1.0
In-Reply-To: <5326F8C5.5090406@ti.com>
References: <5316FFCE.1060603@ti.com>
	<1394018461-757-1-git-send-email-holler@ahsoftware.de>
	<CACRpkdaF=jc9Z1XZCtH8VPuih01t--qyV-sgH1R_ix0VM4RzVA@mail.gmail.com>
	<5322D529.4070904@ahsoftware.de>
	<CACRpkdaghneo1MvNCfxjTED+sJepHgeZCgmKsRteG9qrBNWAfQ@mail.gmail.com>
	<5326F8C5.5090406@ti.com>
Date: Mon, 17 Mar 2014 15:05:05 +0100
Message-ID: <CACRpkdYZMzw31NkA4uSq+ZowzOnZgZthXhZri-eJY2Ozb8aNRQ@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: davinci: fix gpio selection for OF
From: Linus Walleij <linus.walleij@linaro.org>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Alexander Holler <holler@ahsoftware.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 2:29 PM, Sekhar Nori <nsekhar@ti.com> wrote:

> One thing to note is that this driver is used by keystone too and all
> its users are DT-only. Although I do not see any in-kernel DT GPIO users
> even there.
>
> I can confirm the patch does not break my gpiolib based test module
> (test with and without DT), but then it did not have an issue even before.

Is that a Tested-by tag? :-)

If you're also convinced that fix is safe I'll push it as a fix to v3.14-rcN
if for nothing else so for getting Mr. Holler to stop poking me in the
chest.

Yours,
Linus Walleij
