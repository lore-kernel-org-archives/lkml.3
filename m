Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3H0U1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:27:50 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:65346 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3H0U1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:27:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAODwPW_W9gu+nwNzpq3sfcOCDkyppu6K8C9+S8OZt_A0qHqNEg@mail.gmail.com>
References: <1375812017-6287-1-git-send-email-jwerner@chromium.org>
	<20130808092615.GF14648@e106331-lin.cambridge.arm.com>
	<CAODwPW-j=JjunZU3zewrE1_-WoW-RXLmKVQypzxmo_BOYjc3VA@mail.gmail.com>
	<1729120.r596vOTlMW@flatron>
	<CAODwPW_W9gu+nwNzpq3sfcOCDkyppu6K8C9+S8OZt_A0qHqNEg@mail.gmail.com>
Date: Tue, 27 Aug 2013 13:27:48 -0700
X-Google-Sender-Auth: ks4MppkJPCS63lka2nUZWtLabeE
Message-ID: <CAODwPW8KG2ZxOFf936H233g35KVPjDp+f8e3qgkd4Z7NN9RAtQ@mail.gmail.com>
Subject: Re: [PATCH 1/3 v5] usb: phy-samsung-usb: Simplify PMU register handling
From: Julius Werner <jwerner@chromium.org>
To: Julius Werner <jwerner@chromium.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*Ping!*

Are there still unanswered concerns left with this patch? I hope my
prior mails could clear up why I think that the PMU register
description in the device tree for a specific PHY is represents the
hardware more accurately after my patch, and my analysis of the
Exynos4 situation currently not being implemented (and therefore not
needing to be addressed by this patch) was correct. Please let me know
if you have further objections... and if not, could we agree to have
this picked up somewhere?

Thanks,
Julius
