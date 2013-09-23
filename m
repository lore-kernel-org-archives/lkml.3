Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3IWTlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:41:45 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:54117 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3IWTlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:41:44 -0400
MIME-Version: 1.0
In-Reply-To: <5230C7F6.3080803@wwwdotorg.org>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de>
	<52279524.8090006@wwwdotorg.org>
	<20130909161924.GT29403@sirena.org.uk>
	<2052193.CMUEUJFRgS@lem-wkst-02>
	<522F78CB.2020507@wwwdotorg.org>
	<20130910213718.GH29403@sirena.org.uk>
	<522F9E6C.2010905@wwwdotorg.org>
	<522FBED9.9000305@collabora.co.uk>
	<5230C7F6.3080803@wwwdotorg.org>
Date: Mon, 23 Sep 2013 21:41:43 +0200
Message-ID: <CACRpkdZxFpw=EYB4A4nZu7LWjQb6QppVctUsBBDiCMsCBbqm5A@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mark Brown <broonie@kernel.org>, Lars Poeschel <poeschel@lemonage.de>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>,
        joelf@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 9:43 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/10/2013 06:52 PM, Javier Martinez Canillas wrote:

>> I'm a bit confused now. Doesn't the fact that gpio_request() prevents
>> double-requests mean that the use-case that you say that have not been covered
>> by this patch can't actually happen?
>>
>> I mean, if when using board files an explicit call to gpio_request() is made by
>> platform code then a driver can't call gpio_request() for the same gpio. So this
>> patch shouldn't cause any regression since is just auto-requesting a GPIO when
>> is mapped as an IRQ in a DT which basically will be the same that was made by
>> board files before.
>
> I'm not familiar with the board file path; Linus describe this.

Oh um? Not following, that stuff is right above, what is unclear
about this that I need to describe?

Yours,
Linus Walleij
