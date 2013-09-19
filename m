Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3ISHMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 03:12:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:34953 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab3ISHMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 03:12:38 -0400
Message-ID: <1379574653.6148.62.camel@pasglop>
Subject: Re: [dtc RFC PATCH] Enforce node name unit-address presence/absence
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Jon Loeliger <jdl@jdl.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Frank Rowand <frowand.list@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Date: Thu, 19 Sep 2013 17:10:53 +1000
In-Reply-To: <CAOesGMg0Rrmew0iK-Gtrx_UiODhpro_S2xUxQi0gZ+7PJmBHnw@mail.gmail.com>
References: <1379535836-12726-1-git-send-email-swarren@wwwdotorg.org>
	 <CAOesGMg0Rrmew0iK-Gtrx_UiODhpro_S2xUxQi0gZ+7PJmBHnw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 13:41 -0700, Olof Johansson wrote:
> Also, maybe warn for @0x<foo>, which is another unpreferred syntax, it
> should just be @<foo> (with foo being in hex).

It can also bee @foo,bar, it doesn *have* to match the exact content of
the reg property first entry. In fact it's not uncommon to use a 64-bit
value here on 64-bit processors and pci uses a different encoding scheme
(on real OFW at least) where they typically do @dev,fn

Yes, the fact that the unit address is not something deterministic is
and has always been a major PITA though.

Cheers,
Ben.


