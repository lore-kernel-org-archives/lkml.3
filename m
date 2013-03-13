Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931Ab3CMQ7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:59:18 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:41035 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933897Ab3CMQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:59:12 -0400
MIME-Version: 1.0
In-Reply-To: <5140AF22.2030809@wwwdotorg.org>
References: <1360957573-864-1-git-send-email-dianders@chromium.org>
	<1363192583-26363-1-git-send-email-dianders@chromium.org>
	<5140AF22.2030809@wwwdotorg.org>
Date: Wed, 13 Mar 2013 09:59:10 -0700
X-Google-Sender-Auth: vYbcJHELvuhXse9NMA4i1at9pT0
Message-ID: <CAD=FV=VOmXW4awSozKaC1GoerEfomVhaJ-j950S1x28Js2oVpg@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] i2c: mux: Add i2c-arbitrator-cros-ec 'mux' driver
From: Doug Anderson <dianders@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-doc@vger.kernel.org, Daniel Kurtz <djkurtz@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Grant Grundler <grundler@chromium.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jean Delvare <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        "bhushan.r" <bhushan.r@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "sreekumar.c" <sreekumar.c@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Prashanth G <prashanth.g@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Wed, Mar 13, 2013 at 9:53 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> Changes in v4: None
>
> Isn't this 'PATCH V3 REPOST' then?

In this case part 2 in the patch series changes but not parts 1 and 3.
 I could have just reposted part 2 with a higher version, but that
makes it a little harder to piece together all of the parts of the
series so I decided to repost all 3.  I can do differently in the
future if you prefer, but my understanding was that it was a matter of
preference/judgement call.

Thanks!  :)

-Doug
