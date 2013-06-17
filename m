Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab3FQLck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:32:40 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:39213 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab3FQLcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:32:39 -0400
MIME-Version: 1.0
In-Reply-To: <1369995191-20855-2-git-send-email-gururaja.hebbar@ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
	<1369995191-20855-2-git-send-email-gururaja.hebbar@ti.com>
Date: Mon, 17 Jun 2013 13:32:38 +0200
Message-ID: <CACRpkdZjvW6M1Q+K3OD1x_Jkz91AofdOdBThyJLGJ+Wx-BDTNw@mail.gmail.com>
Subject: Re: [PATCH 01/11] pinctrl: single: adopt pinctrl sleep mode management
From: Linus Walleij <linus.walleij@linaro.org>
To: Hebbar Gururaja <gururaja.hebbar@ti.com>,
        ext Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vaibhav Bedia <vaibhav.bedia@ti.com>, sudhakar.raj@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 12:13 PM, Hebbar Gururaja
<gururaja.hebbar@ti.com> wrote:

> Make pinctrl-single able to handle suspend/resume events and change
> hogged pins states accordingly.
>
> Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Noone said anything about this patch, but it looks very straight-forward
to me and seems sound so I have applied it.

If Tony or Haojian has strong feelings about it I will dequeue it.

Yours,
Linus Walleij
