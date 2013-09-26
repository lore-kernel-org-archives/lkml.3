Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab3IZK52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:57:28 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:55594 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab3IZK50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:57:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130924182820.GA9911@mithrandir>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
	<1379320326-13241-3-git-send-email-treding@nvidia.com>
	<CACRpkdYo8knzZ+Z-tc7fyEGwX5bt4RvMU3TR3k3UrOj0KRJocw@mail.gmail.com>
	<20130923202935.GA5216@ulmo>
	<CACRpkdZMM9RUkRCWG0mYbF9PL-fOdDncpY05xG3F5BF55hn5ug@mail.gmail.com>
	<20130924182820.GA9911@mithrandir>
Date: Thu, 26 Sep 2013 12:57:25 +0200
Message-ID: <CACRpkdYzcb1F1-YK5ivxGpskZyVxN3qfUGn8sqq9RnfOU-EzEQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] irqdomain: Introduce __irq_create_mapping()
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 8:28 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:

> Given that linux-next might not be with us for much longer before the
> 3.12 release, I'm thinking of deferring the series until then. Or at
> least trying to get it merged. Otherwise we'll probably have to deal
> with a lot of fall out during the merge window.

Hm, how unfortunate. Typically this is the kind of topic branch
that should go in separately to linux-next.

> In any case, it'd be nice to get some feedback on the general idea of
> the patch series from other people involved. I'd hate to do all the
> conversions just to have it NAKed at the last minute.

With the direction we've discussed here atleast I won't be
doing any NACKing if it's of any help...

Yours,
Linus Walleij
