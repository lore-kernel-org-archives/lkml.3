Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbaGXOVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:21:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54279 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759097AbaGXOVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:21:38 -0400
Message-ID: <53D11667.8050807@ti.com>
Date: Thu, 24 Jul 2014 10:21:27 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grygorii Strashko <grygorii.strashko@ti.com>, Suman Anna <s-anna@ti.com>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        <ivan.khoronzhuk@ti.com>, Muralidharan Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] gpio: keystone: add dsp gpio controller driver
References: <1405507426-18992-1-git-send-email-grygorii.strashko@ti.com>	<CACRpkdYY_a_9G-VLBbv2a22Cg4j0t3Wv4W1h0n6-ccCXgVJXsA@mail.gmail.com>	<53CFD404.7070704@ti.com> <CACRpkdYdUKmR+bZo374AqepDXfsZqBwJ88e4is90-UoUBWdJrA@mail.gmail.com>
In-Reply-To: <CACRpkdYdUKmR+bZo374AqepDXfsZqBwJ88e4is90-UoUBWdJrA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2014 10:12 AM, Linus Walleij wrote:
> On Wed, Jul 23, 2014 at 5:25 PM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
> 
>> I will try to answer this. This IP is indeed a GPIO block
>> but the IO's are used just OUTPUT lines from Linux
>> HOST perspective. These IOs are connected to the DSPs
>> as input/IRQ lines.
> 
> So the DSP is another discrete IC, and could be something
> different, so this is board-level information?
> 
> I'm really worrying whether this is general purpose or not :-/
> 
Am not sure I follow you. This IP is completely controlled
by Linux OS to generate output signals. How does it matter
whether its connected to a peripheral or a discrete IC. For
example instead of DSP if I connected these lines to an
external PMIC, which considers these as input lines to
perform some actions. Isn't that GPIO usecase as per you ?
Given that this IP only output functionality is used but
that shouldn't matter. We have seen SOCs where GPIOs
are just used as input to form a Matrix Keyboard.

May be I am missing your point.

Regards,
Santosh



