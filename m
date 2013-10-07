Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab3JGIj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 04:39:27 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:37522 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab3JGIj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 04:39:26 -0400
Message-ID: <52527339.9090701@gmail.com>
Date: Mon, 07 Oct 2013 10:39:21 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Mike Turquette <mturquette@linaro.org>
CC: Andrew Lunn <andrew@lunn.ch>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: provide public clk_is_enabled function
References: <1380881310-24345-1-git-send-email-sebastian.hesselbarth@gmail.com> <20131005202430.GI10079@pengutronix.de> <20131005204208.GB28106@lunn.ch> <20131006090609.GK14747@book.gsilab.sittig.org> <20131006163011.GA30818@lunn.ch> <5251BD09.3050900@gmail.com> <20131006200223.32214.4440@quantum> <5251E334.2070008@gmail.com> <CAPtuhTiaTX1VX0OnkJN6AeqtT+FW+uK7022iJ2wOCirQmMXH4Q@mail.gmail.com>
In-Reply-To: <CAPtuhTiaTX1VX0OnkJN6AeqtT+FW+uK7022iJ2wOCirQmMXH4Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2013 11:04 PM, Mike Turquette wrote:
> On Sun, Oct 6, 2013 at 3:24 PM, Sebastian Hesselbarth
> <sebastian.hesselbarth@gmail.com> wrote:
>> Of course, we can do clk_enable, read, clk_disable as said before - and
>> given the amount of questions and misinterpretation, I think it is the
>> saner way.
>
> Sorry for any misinterpretation on my end. I agree reading the
> register(s) within a clk_enable/clk_disable-protected section is the
> most sane option.

Well, as you are not the only one misinterpreting the purpose, I
guess it is more about the clk_is_enabled() function itself. Uwe was
very right, that it will lead to patches using it in a wrong way.

Using the common enable/disable functions does no harm to our workaround
and we will use it.

Thanks for taking the time to raise those questions and surface those
critical interpretations early!

Sebastian

