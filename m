Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3JVP0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:26:10 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43692 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3JVP0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:26:07 -0400
Message-ID: <5266990A.5040907@baylibre.com>
Date: Tue, 22 Oct 2013 17:26:02 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        =?UTF-8?B?J1BhbGkgUm9ow6FyJw==?= <pali.rohar@gmail.com>,
        =?UTF-8?B?J9CY0LI=?=
	 =?UTF-8?B?0LDQudC70L4g0JTQuNC80LjRgtGA0L7Qsic=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>
Subject: Re: [RFCv3 7/7] ARM: dts: N900: Add SSI information
References: <1381091235-18293-1-git-send-email-sre@debian.org> <1381091235-18293-8-git-send-email-sre@debian.org> <5266742D.9050604@baylibre.com> <20131022144413.GA31867@earth.universe>
In-Reply-To: <20131022144413.GA31867@earth.universe>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On 22/10/2013 16:44, Sebastian Reichel wrote:
> Hi Benoit,
>
> On Tue, Oct 22, 2013 at 02:48:45PM +0200, Benoit Cousson wrote:
>> Thanks to Tony, I've just realized that I missed all your patches,
>> that for some reason ended-up in my junk folder :-(
>
> oh :( Can you check why they ended up in junk? I would like to
> prevent more mails going there.
>
>> That being said, I cannot apply any of your DTS patches! What base
>> branch are you using?
>
> Currently torvalds/master with pavel's n900 patch and some more
> patches from me.

Mmm, looks like I missed these patches :-)

>
>> Could you repost all your pending DTS patches in one series rebased
>> on top of my for_3.13/dts?
>
> Sure. DT maintainers haven't given feedback since the last patchset
> [0]. Do you want to wait for feedback from them?

OK, maybe not the SSI series that is still RFC, but I guess all the 
others ones are fine to be merged.

Could you repost the whole N900 DTS patches (beside SSI) in one series 
rebased on top of mine?

Thanks,
Benoit

>
> [0] https://lkml.org/lkml/2013/9/23/529
>
> -- Sebastian
>


-- 
Benoît Cousson
BayLibre
Embedded Linux Technology Lab
www.baylibre.com
