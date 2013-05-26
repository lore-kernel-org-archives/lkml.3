Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab3EZQLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 12:11:24 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:64473 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3EZQLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 12:11:11 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZEsRaaE9dJLDNMzJZSLZ35pqS6XVj5KgCzJGG5nnvPQg@mail.gmail.com>
References: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
	<CACRpkdZEsRaaE9dJLDNMzJZSLZ35pqS6XVj5KgCzJGG5nnvPQg@mail.gmail.com>
Date: Mon, 27 May 2013 00:11:10 +0800
Message-ID: <CAD6h2NTPp9BdxpjjQig1B-gVk+7PvxBvtUKi=kcbiUQeQ5wYjA@mail.gmail.com>
Subject: Re: [PATCH 0/3] pinctrl: pinctrl-single: Add full fledge support to
 configure multiple pins of different modules
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        ext Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Landley <rob@landley.net>,
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

On 24 May 2013 17:03, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, May 21, 2013 at 4:07 PM, Manjunathappa, Prakash
> <prakash.pm@ti.com> wrote:
>
>> Based function-mask and submask preoperties patch allocates and registers pins.
>> Patch is fixes the issue reported and discussed here:
>> http://www.spinics.net/lists/arm-kernel/msg235213.html
>
> I'd like Tony to ACK this, and Haojian to have a look at it before applying.
>
> Yours,
> Linus Walleij

I'll give feedback in the next week.

Regards
Haojian
