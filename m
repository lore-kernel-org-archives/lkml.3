Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaCLOwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:52:16 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41803 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbaCLOwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:52:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140308115045.GL3327@book.gsilab.sittig.org>
References: <1393842463-5206-1-git-send-email-thloh@altera.com>
	<CACRpkdbwKuaTucbHbuXsKpRAg+kN27K6uN212TT1-h8wxY9YzA@mail.gmail.com>
	<20140308115045.GL3327@book.gsilab.sittig.org>
Date: Wed, 12 Mar 2014 15:52:12 +0100
Message-ID: <CACRpkdZQdz78mdSJYaVsk3Xs1m7Eefh-d1e3LHew9VYxzSkObA@mail.gmail.com>
Subject: Re: [PATCH V7 1/1] drivers/gpio: Altera soft IP GPIO driver and
 devicetree binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Gerhard Sittig <gsi@denx.de>
Cc: Tien Hock Loh <thloh@altera.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        "lftan@altera.com" <lftan@altera.com>,
        Tien Hock Loh <thloh.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 8, 2014 at 12:50 PM, Gerhard Sittig <gsi@denx.de> wrote:
> On Fri, Mar 07, 2014 at 11:31 +0800, Linus Walleij wrote:
>>
>> On Mon, Mar 3, 2014 at 6:27 PM,  <thloh@altera.com> wrote:
>>
>> > From: Tien Hock Loh <thloh@altera.com>
>> >
>> > Add driver support for Altera GPIO soft IP, including interrupts and I/O.
>> > Tested on Altera CV SoC board using dipsw and LED using LED framework.
>> >
>> > Signed-off-by: Tien Hock Loh <thloh@altera.com>
>>
>> Can I get some ACKs on this? Like from Gerhard, DT folks?
>>
>> Or is there still more things to do?
>
> Sorry, had flagged the patch for review, but did not get around
> to respond earlier.  No ACK from me for v7 as it is.

OK I'm holding this back.

> Am I supposed to provide ACKs at all, given that I'm a reviewer
> and fellow developer.  I always understood that Acked-By is
> something more formal, where one maintainer signals to another
> maintainer that it's OK to go though a different tree.

In this case I want an Acked-by/Reviewed-by tag (choose!)
beacuse I trust your ability to review this specific code, as simple as
that.  :-)

Yours,
Linus Walleij
