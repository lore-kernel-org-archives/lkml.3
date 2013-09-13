Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3IMUw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:52:58 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:65035 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3IMUw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:52:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130913191530.GV29403@sirena.org.uk>
References: <1378065659-18135-1-git-send-email-linus.walleij@linaro.org>
	<20130901201321.GB23687@sirena.org.uk>
	<CACRpkdapBc6pRTTpnM3VWErMyzz1So_50H9_efsxXaEO_JLV7A@mail.gmail.com>
	<20130913191530.GV29403@sirena.org.uk>
Date: Fri, 13 Sep 2013 22:52:57 +0200
Message-ID: <CACRpkdbqQkrftjkzomEAyBSPSL9cGGOwNMrtWn+Dv+J-hQoOYg@mail.gmail.com>
Subject: Re: [PATCH 2/4] regulator: add STw481x VMMC driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 9:15 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Sep 13, 2013 at 09:00:08PM +0200, Linus Walleij wrote:
>> On Sun, Sep 1, 2013 at 10:13 PM, Mark Brown <broonie@kernel.org> wrote:
>
>> > I can put it on a branch so it can be pulled into arm-soc - it makes
>> > life easier for framework refactorings to have the driver in the
>> > regulator tree as well.  Would that be OK?
>
>> Sure but then you need patch 1/4 in there as well. I don't know if that
>
> It shouldn't do, the Kconfig dependencies should stop it actually
> getting built until the MFD is merged into the same tree I'd expect?

Yes you're right of course. It's just me being sensitive about
things like it's including yet non-existant headers etc. It is indeed
possible to apply it right off.

> But if it is required then I'm fine with it going via arm-soc only, it's
> just easier to avoid mistakes if there's no new drivers in other trees.

There's no need if we are convinced the MFD driver goes in
through the MFD tree.

The ARM SoC tree changes are only DT changes and those
could anyway live in through a stand-alone git the other day.

>> comment pertained to the situation prior to the v3.12 merge window
>> though, can I take this in now maybe or is there still a stir in the
>> regulator tree?
>
> There's still stuff going on - devm_regulator_register() is the main one
> I'm thinking of immediately.

OK better handle it there then. Feel free to apply when you're
happy with it.

Yours,
Linus Walleij
