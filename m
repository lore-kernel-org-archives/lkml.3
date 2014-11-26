Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaKZKIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 05:08:47 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:58485 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaKZKIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 05:08:44 -0500
MIME-Version: 1.0
In-Reply-To: <20141125171234.GH7712@sirena.org.uk>
References: <1416918506-9366-1-git-send-email-romain.perier@gmail.com>
	<1416918506-9366-2-git-send-email-romain.perier@gmail.com>
	<20141125144007.9904BC44343@trevor.secretlab.ca>
	<20141125145410.GD19910@localhost>
	<CABgxDoKUecAd00X0znkGiQncF4MwnLAM4BFV2AV_oMPF=4G7UA@mail.gmail.com>
	<20141125171234.GH7712@sirena.org.uk>
Date: Wed, 26 Nov 2014 11:08:43 +0100
Message-ID: <CABgxDoJoVNxXp0qXKKofbOywvMV-=4vBnABq+y6kwgCkaFWnQg@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] of: Rename "poweroff-source" property to "system-power-controller"
From: Romain Perier <romain.perier@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, robh <robh@kernel.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-25 18:12 GMT+01:00 Mark Brown <broonie@kernel.org>:
> Yeah, given the amount of often late arriving disagreement I'd rather
> let things cook for a while unless there are a lot of people being vocal
> about this being what we want to go with.

In other words, I need more reviews and more positives feedbacks about
this serie (as far as people who were against the previous ones).
For example, Feedbacks from Felipe Balbi and Lucas Stach would be welcome.

Thanks,
Romain
