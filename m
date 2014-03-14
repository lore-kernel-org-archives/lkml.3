Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaCNNyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:54:04 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:53131 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbaCNNyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:54:01 -0400
MIME-Version: 1.0
In-Reply-To: <5322F82A.9000507@ahsoftware.de>
References: <5316FFCE.1060603@ti.com>
	<1394018461-757-1-git-send-email-holler@ahsoftware.de>
	<CACRpkdaF=jc9Z1XZCtH8VPuih01t--qyV-sgH1R_ix0VM4RzVA@mail.gmail.com>
	<5322D529.4070904@ahsoftware.de>
	<CACRpkdaghneo1MvNCfxjTED+sJepHgeZCgmKsRteG9qrBNWAfQ@mail.gmail.com>
	<5322F82A.9000507@ahsoftware.de>
Date: Fri, 14 Mar 2014 14:54:00 +0100
Message-ID: <CACRpkdZscprsy7kyqHPUMEMYJ_TKgG2bYR7mdrG4hTDp1w1nDg@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: davinci: fix gpio selection for OF
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        Sekhar Nori <nsekhar@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 1:38 PM, Alexander Holler <holler@ahsoftware.de> wrote:

>> In that case it is hardly a fix that we need to rush out to the entire
>> world.
>
> And I thought the reason for -rc is actually to fix bugs. But I never
> understood the magical ways and timings patches make their way into
> mainline. ;)

OK so it works like this: early in the -rc cycle we fix any bugs, documentation
or whatever. At this point it's *regressions* so the fix need to fix something
that broke in the merge window (or an earlier merge window).

If it is a new feature that never worked in the first place I would
not call that
a regression. There are no existing users out there that can experience
regressions from a previously working system.

So this is why I'm a bit conservative.

Yours,
Linus Walleij
