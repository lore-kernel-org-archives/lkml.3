Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab3FGLOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:14:04 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58297 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab3FGLOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:14:01 -0400
MIME-Version: 1.0
In-Reply-To: <1369145282-14419-4-git-send-email-prakash.pm@ti.com>
References: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
	<1369145282-14419-4-git-send-email-prakash.pm@ti.com>
Date: Fri, 7 Jun 2013 13:14:00 +0200
Message-ID: <CACRpkdbb49jq6gF0OMtsHko1toarARJaF8NOcxZ5bsiYO7pk3g@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: pinctrl-single: pin names for pinctrl-single.bits
From: Linus Walleij <linus.walleij@linaro.org>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Landley <rob@landley.net>, ext Tony Lindgren <tony@atomide.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 4:08 PM, Manjunathappa, Prakash
<prakash.pm@ti.com> wrote:

> Take care to name pin names as
> register-offset.bit-pos-of-pin-in-register in case configuring multiple
> pins in register.
>
> Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>

Applied with Haojian and Tony's ACKs.

Thanks!
Linus Walleij
