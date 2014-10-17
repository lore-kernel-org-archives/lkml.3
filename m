Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaJQGBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 02:01:33 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:37017 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaJQGBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 02:01:32 -0400
MIME-Version: 1.0
In-Reply-To: <20141015140337.GI27755@sirena.org.uk>
References: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
	<20141015124142.92D0EC40B00@trevor.secretlab.ca>
	<20141015134245.GH27755@sirena.org.uk>
	<40398493.mf2VbOGMuV@phil>
	<20141015140337.GI27755@sirena.org.uk>
Date: Fri, 17 Oct 2014 08:01:31 +0200
Message-ID: <CABgxDoKen1Ub1ptG85-oMhUcRkX7tsZ6o51OJcOX2jZkZi0JGg@mail.gmail.com>
Subject: Re: [RFC v3 PATCH 1/5] of: Add standard property for poweroff capability
From: PERIER Romain <romain.perier@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Grant Likely <grant.likely@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        robh <robh@kernel.org>, mark.rutland@arm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am just curious but where do you plan to merge this serie ? in
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git ?

You have conflicts because I use linux-next as base repository.


Thanks for your feebacks (all of you).
Romain

2014-10-15 16:03 GMT+02:00 Mark Brown <broonie@kernel.org>:
> On Wed, Oct 15, 2014 at 03:56:03PM +0200, Heiko Stübner wrote:
>> Am Mittwoch, 15. Oktober 2014, 15:42:45 schrieb Mark Brown:
>
>> > I guess I should apply these (except the DTS update) since the first
>> > user that's being added is a regulator driver?
>
>> I'd think so.
>> In any case, I'll take the "ARM: dts: ..." patch if you take the others.
>
> Sounds like a plan.  I just tried applying and got some conflicts but
> I'm guessing that this is due to changes that are landing in the merge
> window so I'll try again once -rc1 is out.
