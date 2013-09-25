Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3IYWWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:22:44 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:44488 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3IYWWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:22:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMi=xBXTdMm+-yTRVVFf0VR-7gy6xTrdeAupyo7OWVb3iQ@mail.gmail.com>
References: <1378986619-26765-1-git-send-email-pekon@ti.com>
	<1378986619-26765-2-git-send-email-pekon@ti.com>
	<20980858CB6D3A4BAE95CA194937D5E73EA15ED7@DBDE04.ent.ti.com>
	<20130925134619.GG10746@radagast>
	<20130925175527.GA23337@ld-irv-0074.broadcom.com>
	<20980858CB6D3A4BAE95CA194937D5E73EA16884@DBDE04.ent.ti.com>
	<20130925200539.GH23337@ld-irv-0074.broadcom.com>
	<CAOesGMif301iBe9zxHudkC_G9SzPPy1Mj4XYvQ-MY8nmx4wO+A@mail.gmail.com>
	<20130925212903.GI23337@ld-irv-0074.broadcom.com>
	<CAOesGMi=xBXTdMm+-yTRVVFf0VR-7gy6xTrdeAupyo7OWVb3iQ@mail.gmail.com>
Date: Wed, 25 Sep 2013 15:22:41 -0700
Message-ID: <CAN8TOE9Mo6sHWjy7ebtxTqZoDTM9dzcBqdu_qsZfP_ELtSufWw@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] ARM: OMAP2+: cleaned-up DT support of various ECC schemes
From: Brian Norris <computersforpeace@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: "Gupta, Pekon" <pekon@ti.com>,
        "benoit.cousson@linaro.org" <benoit.cousson@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "avinashphilipk@gmail.com" <avinashphilipk@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 2:32 PM, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Sep 25, 2013 at 2:29 PM, Brian Norris
> <computersforpeace@gmail.com> wrote:
>> On Wed, Sep 25, 2013 at 01:33:27PM -0700, Olof Johansson wrote:
>>> On Wed, Sep 25, 2013 at 1:05 PM, Brian Norris
>>> <computersforpeace@gmail.com> wrote:
>>>
>>> > Olof has given good advice on your DT binding and has (slowly) been
>>> > responding to other requests for DT review that make it to his list. I
>>> > see that he hasn't followed up on your changes (this v6), so pinging him
>>> > (as you did) is probably the correct approach. But please do recognize
>>> > that the DT list is very high volume, so it's hard to get good timely
>>> > responses there.
>>>
>>> I am not a DT mainainer, but sometimes when I see a binding that
>>> appears to be wrong I speak up. In this case, the binding was one of
>>> those.
>>
>> Whoops, my bad. I was deceived by the responses I've seen from you on
>> other issues (thanks, BTW). In that case, I haven't seen any response
>> from a proper DT binding maintainer :(
>>
>>> So, I have no more objections to it, and I hope you can get a quick
>>> review from a DT maintainer on the rest of the binding.
>>
>> At this point, I'm comfortable going ahead without their ack, since they
>> obviously don't care/don't have the manpower to review.
>
> No, that is not how we handle device tree bindings. They need to be
> reviewed, since we are moving over to a model where they will be
> considered ABI and can't be changed after the fact. We have a long
> backlog of mostly-unreviewed old bindings that we're going to do a
> pass through and then lock down, but it would be good to not add to
> that backlog with newer bindings.
>
> In other words, there's a strong desire for actual acks on bindings
> from those maintainers these days.

This only works if we get a response. I'll repeat this fact: I have
seen absolutely zero response from any DT maintainer regarding this
binding, and they've been CC'd in some capacity since July:

Old revision from July (cross-posted, including the old DT list):
http://thread.gmane.org/gmane.linux.ports.arm.omap/100484/

New list:
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg95238.html

All official DT binding maintainers are CC'd here: you can't say you
want more review of bindings, yet fail to review them across 3
versions and almost 3 months. Ball's in your court.

Brian
