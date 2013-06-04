Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3FDK7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 06:59:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63764 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3FDK73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 06:59:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130604095657.GA9581@balto.lan>
References: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
	<1369920465-13905-5-git-send-email-fabio.baltieri@linaro.org>
	<CACRpkda8h_zewd2M7QzvoLn15iDEUv8XYCGqro62chiCcYaM8Q@mail.gmail.com>
	<20130604095657.GA9581@balto.lan>
Date: Tue, 4 Jun 2013 12:59:28 +0200
Message-ID: <CACRpkda6L+mr-CYSmLY9i=uE4dZiXfo1QhtbfBjxo2mC2orK-g@mail.gmail.com>
Subject: Re: [PATCH 4/5] ARM: ux500: Provide auxdata to ux500 ASoC driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 11:56 AM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:
> On Tue, Jun 04, 2013 at 11:03:41AM +0200, Linus Walleij wrote:
>>
>> Patch applied to my ux500-devicetree branch after some rebasing.
>
> Thanks!  I saw that a lot patches are stacking up in the tree, do you
> plan to send an intermediate pull request to get these on
> arm-soc/for-next (and linux-next)?

Yes it's just that new things come in all the time.

I might just draw a line at some point and say any more
changes need to go into v3.12.

Yours,
Linus Walleij
