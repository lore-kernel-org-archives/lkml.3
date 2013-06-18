Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab3FRMOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:14:05 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35059 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab3FRMOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:14:03 -0400
MIME-Version: 1.0
In-Reply-To: <32351.1371553495@ale.ozlabs.ibm.com>
References: <1371244086-9189-1-git-send-email-grant.likely@linaro.org>
 <1371244086-9189-9-git-send-email-grant.likely@linaro.org>
 <4521.1371518445@ale.ozlabs.ibm.com> <5220.1371518734@ale.ozlabs.ibm.com>
 <CACxGe6s+K0xF0pnLjKoKXtz_YNoeM2+erhr_g2dX4ONpddRNGA@mail.gmail.com>
 <20130618094617.9BFA93E0D88@localhost> <32351.1371553495@ale.ozlabs.ibm.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Tue, 18 Jun 2013 13:13:42 +0100
X-Google-Sender-Auth: DP-xfONz1dYXbOkuzKAJXeX2lu4
Message-ID: <CACxGe6spx0wP2ceVcP1AqZwOUE+Ki9Ug1ksfRQG3DMWxpfiG8A@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] irqdomain: Refactor irq_domain_associate_many()
To: Michael Neuling <mikey@neuling.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-next <linux-next@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 12:04 PM, Michael Neuling <mikey@neuling.org> wrote:
> Grant Likely <grant.likely@linaro.org> wrote:
>
>> On Tue, 18 Jun 2013 10:05:31 +0100, Grant Likely <grant.likely@linaro.org> wrote:
>> > On Tue, Jun 18, 2013 at 2:25 AM, Michael Neuling <mikey@neuling.org> wrote:
>> > > Michael Neuling <mikey@neuling.org> wrote:
>> > >
>> > >> Grant,
>> > >>
>> > >> In next-20130617 we are getting the below crash on POWER7.  Bisecting,
>> > >> points to this patch (d39046ec72 in next)
>> > >
>> > > Also, reverting just d39046ec72 fixes the crash in next-20130617.
>> >
>> > Odd. Of all the changes in that series, I would not have expected that
>> > one to cause any problems. I'm digging into it now...
>>
>> Ugh. I flubbed the commit. Try this patch. It should solve the problem:
>>
>
> Yep, it fixes it.  Thanks.

Excellent, thanks for testing.

g.
