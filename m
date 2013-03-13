Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872Ab3CMR3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:29:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38412 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab3CMR3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:29:35 -0400
Message-ID: <5140B778.7090401@wwwdotorg.org>
Date: Wed, 13 Mar 2013 11:29:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>,
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
Subject: Re: [PATCH v4 1/3] i2c: mux: Add i2c-arbitrator-cros-ec 'mux' driver
References: <1360957573-864-1-git-send-email-dianders@chromium.org> <1363192583-26363-1-git-send-email-dianders@chromium.org> <5140AF22.2030809@wwwdotorg.org> <CAD=FV=VOmXW4awSozKaC1GoerEfomVhaJ-j950S1x28Js2oVpg@mail.gmail.com>
In-Reply-To: <CAD=FV=VOmXW4awSozKaC1GoerEfomVhaJ-j950S1x28Js2oVpg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 10:59 AM, Doug Anderson wrote:
> Stephen,
> 
> On Wed, Mar 13, 2013 at 9:53 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> Changes in v4: None
>>
>> Isn't this 'PATCH V3 REPOST' then?
> 
> In this case part 2 in the patch series changes but not parts 1 and 3.
>  I could have just reposted part 2 with a higher version, but that
> makes it a little harder to piece together all of the parts of the
> series so I decided to repost all 3.  I can do differently in the
> future if you prefer, but my understanding was that it was a matter of
> preference/judgement call.

Oh no you're quite right. I didn't notice it was a 3-part series, since
I only got patch 1/3 filtered into my inbox; I guess I wasn't CC'd on
the rest. Sorry for the noise.
