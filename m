Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaI1NZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 09:25:05 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:52870 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbaI1NZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 09:25:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140928122543.GA27755@sirena.org.uk>
References: <1411834906-9533-1-git-send-email-romain.perier@gmail.com>
	<20140928103301.GN27755@sirena.org.uk>
	<CABgxDo+h2AYjAO4darK4+RTXqnhf4OqouGLfF2yuJCpu7r6tLg@mail.gmail.com>
	<20140928122543.GA27755@sirena.org.uk>
Date: Sun, 28 Sep 2014 15:25:00 +0200
Message-ID: <CABgxDo+Gor=xnOV83Oca6kez7Auyu95XpaOr7QW+iRHbtByGAg@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] regulator: act8865: Add support to turn off all outputs
From: PERIER Romain <romain.perier@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-28 14:25 GMT+02:00 Mark Brown <broonie@kernel.org>:
> On Sun, Sep 28, 2014 at 02:00:54PM +0200, PERIER Romain wrote:
>> 2014-09-28 12:33 GMT+02:00 Mark Brown <broonie@kernel.org>:
>
>> > We really need to come up with a standard property for this and document
>> > it rather than continuing to add individual device specific properties
>> > all doing the same thing, and probably also some helper code and/or a
>> > standard operation for this - there's a lot of drivers implementing the
>> > same pattern here.
>
>> I completly agree about adding a unified and generic property for that purpose.
>> I already proposed something for that on devicetree ML, see the thread
>> "Proposal: generic property for system-power-controller".
>> Unfortunately I did not get replies :) .
>
> Did you CC relevant maintainers and send a patch?

No I did not propose patches as I was an open discussion. Perhaps I
might propose something as part of my contribution for act8865... (at
least for the property)
