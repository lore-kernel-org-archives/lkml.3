Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3LSSGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:06:37 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:60014 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638Ab3LSSGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:06:32 -0500
From: arno@natisbad.org (Arnaud Ebalard)
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, rtc-linux@googlegroups.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Peter Huewe <peter.huewe@infineon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <treding@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: Can someone Ack and queue a patch for RTC subsytem?
References: <87siton6ke.fsf@natisbad.org>
	<20131219173857.0a546b99@linux.lan.towertech.it>
	<87d2kslphr.fsf@natisbad.org>
	<20131219184024.2a649328@linux.lan.towertech.it>
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
X-Hashcash: 1:20:131219:linux@roeck-us.net::xXL4YnyhVhF+NBru:000000000000000000000000000000000000000000008D4
X-Hashcash: 1:20:131219:akpm@linux-foundation.org::Qv5XfukYinudPJtp:0000000000000000000000000000000000001CBP
X-Hashcash: 1:20:131219:linus.walleij@linaro.org::qoOKwRlM9nu3Qbfs:00000000000000000000000000000000000000TO0
X-Hashcash: 1:20:131219:sfr@canb.auug.org.au::nYEqSYkSImjEzJ00:00000000000000000000000000000000000000000143L
X-Hashcash: 1:20:131219:a.zummo@towertech.it::XZHkgrr7ujdGGLgv:000000000000000000000000000000000000000001IBk
X-Hashcash: 1:20:131219:jgunthorpe@obsidianresearch.com::cx051GUFxn/KCs9Q:0000000000000000000000000000001XXM
X-Hashcash: 1:20:131219:jason@lakedaemon.net::K4FuoQmA6OVdCveV:000000000000000000000000000000000000000002WPp
X-Hashcash: 1:20:131219:grant.likely@linaro.org::yFvVb2ZVBAYyoOWg:000000000000000000000000000000000000002gNQ
X-Hashcash: 1:20:131219:rob@landley.net::hzQijuEGWkNesZ6p:002t9F
X-Hashcash: 1:20:131219:linux-arm-kernel@lists.infradead.org::KMdIFbSuzRDqHzLv:000000000000000000000000029WI
X-Hashcash: 1:20:131219:swarren@wwwdotorg.org::Y7xFO8KqGOTLuRCK:0000000000000000000000000000000000000000470n
X-Hashcash: 1:20:131219:peter.huewe@infineon.com::Wk9dg1fmHd2TWAcP:000000000000000000000000000000000000033tL
X-Hashcash: 1:20:131219:galak@codeaurora.org::RlT3PE/eVRju6kf5:000000000000000000000000000000000000000004KKV
X-Hashcash: 1:20:131219:pawel.moll@arm.com::inuVvGRZljk5gxIZ:00000000000000000000000000000000000000000004FNs
X-Hashcash: 1:20:131219:rob.herring@calxeda.com::fmS32j7hARm7NIuI:000000000000000000000000000000000000004Rp4
X-Hashcash: 1:20:131219:mark.rutland@arm.com::9yeC4ebUbDk3Cy0L:00000000000000000000000000000000000000000691B
X-Hashcash: 1:20:131219:linux-kernel@vger.kernel.org::BffG17CGQbfBiwev:0000000000000000000000000000000004VDF
X-Hashcash: 1:20:131219:broonie@kernel.org::NMhVV3UUu2n/MnS/:00000000000000000000000000000000000000000005ADj
X-Hashcash: 1:20:131219:ijc+devicetree@hellion.org.uk::A4CSgtCgLA8uvNYk:000000000000000000000000000000005w4u
X-Hashcash: 1:20:131219:rtc-linux@googlegroups.com::nfOfsyY1aAZq6woY:000000000000000000000000000000000007nb5
X-Hashcash: 1:20:131219:treding@nvidia.com::kSBmO5miVETFOJ3l:0000000000000000000000000000000000000000000Fvcv
Date: Thu, 19 Dec 2013 19:05:49 +0100
In-Reply-To: <20131219184024.2a649328@linux.lan.towertech.it> (Alessandro
	Zummo's message of "Thu, 19 Dec 2013 18:40:24 +0100")
Message-ID: <8761qkk96q.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Alessandro Zummo <a.zummo@towertech.it> writes:

>> Do you want me to send a v7 w/ the .proc helper removed or leave
>> things as they are and Ack the patch as is?
>
>  Unless absolutely needed, I'd prefer if you can remove them
>  or move to sysfs.

Well, my helper provides info on control and status registers flags
(just like rtc-isl1208.c does), which are useful mainly for debug I
guess. If this can help pushing things forward, I will send a v7 later
today w/ the .proc helper removed from the patch.

Cheers,

a+

