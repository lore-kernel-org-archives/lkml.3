Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965Ab3CMQ7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:59:51 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:57214 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3CMQ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:59:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130310000647.GZ23237@titan.lakedaemon.net>
References: <1362758331.32099.121.camel@i7.infradead.org>
	<513AF783.6050906@gmail.com>
	<1362855725.3690.92.camel@shinybook.infradead.org>
	<20130309225333.GY23237@titan.lakedaemon.net>
	<1362872371.3690.106.camel@shinybook.infradead.org>
	<20130310000647.GZ23237@titan.lakedaemon.net>
Date: Wed, 13 Mar 2013 17:59:49 +0100
Message-ID: <CACRpkdaN4+jM6JYP_m1xcMJ=JY345SFyU_AH6cdUoxWTdEHJ8g@mail.gmail.com>
Subject: Re: memory leak and other oddness in pinctrl-mvebu.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 1:06 AM, Jason Cooper <jason@lakedaemon.net> wrote:

> Added LinusW, Gregory and Ezequiel to the email.  Guys, can you give
> this a Tested-by before I apply (or Ack for LinusW)?

If the Marvell people are happy I'm happy. But I would like to have
some Tested-by from Sebastian or so? Also I don't quite see the
final form of this patch?

And shouldn't I rather take the final patch into the pinctrl tree?

Then there is a larger issue lurking behind this, and that is that
all platforms run their own awkward DT parse code, and that comes
from the fact that we could not agree on a common mapping.
We must think real hard if we can't atleast share some of the
parsing code here.

Yours,
Linus Walleij
