Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab3EXJDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:03:39 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:57346 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab3EXJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:03:37 -0400
MIME-Version: 1.0
In-Reply-To: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
References: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
Date: Fri, 24 May 2013 11:03:36 +0200
Message-ID: <CACRpkdZEsRaaE9dJLDNMzJZSLZ35pqS6XVj5KgCzJGG5nnvPQg@mail.gmail.com>
Subject: Re: [PATCH 0/3] pinctrl: pinctrl-single: Add full fledge support to
 configure multiple pins of different modules
From: Linus Walleij <linus.walleij@linaro.org>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        ext Tony Lindgren <tony@atomide.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>, Grant Likely <grant.likely@linaro.org>,
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

On Tue, May 21, 2013 at 4:07 PM, Manjunathappa, Prakash
<prakash.pm@ti.com> wrote:

> Based function-mask and submask preoperties patch allocates and registers pins.
> Patch is fixes the issue reported and discussed here:
> http://www.spinics.net/lists/arm-kernel/msg235213.html

I'd like Tony to ACK this, and Haojian to have a look at it before applying.

Yours,
Linus Walleij
