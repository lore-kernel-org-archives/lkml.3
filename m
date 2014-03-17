Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbaCQONj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:13:39 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:33098 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbaCQONg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <532702A6.9070309@ahsoftware.de>
References: <5316FFCE.1060603@ti.com>
	<1394018461-757-1-git-send-email-holler@ahsoftware.de>
	<CACRpkdaF=jc9Z1XZCtH8VPuih01t--qyV-sgH1R_ix0VM4RzVA@mail.gmail.com>
	<5322D529.4070904@ahsoftware.de>
	<CACRpkdaghneo1MvNCfxjTED+sJepHgeZCgmKsRteG9qrBNWAfQ@mail.gmail.com>
	<5326F8C5.5090406@ti.com>
	<532702A6.9070309@ahsoftware.de>
Date: Mon, 17 Mar 2014 15:13:35 +0100
Message-ID: <CACRpkdZ_jsG1zyHP10op7zFUwj6giaUNzn0b3O_2S8zcALc5LA@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: davinci: fix gpio selection for OF
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Sekhar Nori <nsekhar@ti.com>,
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

On Mon, Mar 17, 2014 at 3:11 PM, Alexander Holler <holler@ahsoftware.de> wrote:

> Thanks, maybe someone could add a
>
> Cc: <stable@vger.kernel.org>

OK if it goes in as fix I'll add this.

> to get the fix back into 3.14 if it has go through -next.

It's already in linux-next.

Yours,
Linus Walleij
