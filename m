Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbaHYRUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:20:16 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46308 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbaHYRUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:20:14 -0400
Message-ID: <53FB7047.7080508@collabora.co.uk>
Date: Mon, 25 Aug 2014 19:20:07 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Yuvaraj Cd <yuvaraj.lkml@gmail.com>, Mark Brown <broonie@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Prashanth G <prashanth.g@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>, sunil joshi <joshi@samsung.com>
Subject: Re: [PATCH v9 1/2] regulator: Add driver for max77802 PMIC PMIC regulators
References: <1408350762-15520-1-git-send-email-javier.martinez@collabora.co.uk>	<1408350762-15520-2-git-send-email-javier.martinez@collabora.co.uk>	<CA+NduCDL65=Y=PyU3FfXsTz0FfbmYzicGrY4U7ji3_V+nXhtCQ@mail.gmail.com>	<53F73472.8010609@collabora.co.uk>	<20140822144531.GV24407@sirena.org.uk>	<53F7838F.8060906@collabora.co.uk>	<20140822183054.GY24407@sirena.org.uk>	<53F7BDD8.7060500@collabora.co.uk>	<CAD=FV=WC0h7fYm2QFqu3Zka7CsU4BtG-oyPpJav+ygC+gmCR+A@mail.gmail.com>	<CA+NduCCT-KQ=gh7QWkBE4qkA2YOJ8KCVqbkC6Tkmb1aPvCsGFQ@mail.gmail.com>	<53FAFCBC.2050407@collabora.co.uk> <CAD=FV=V4TSKsbjj3dXCdSzVrh3sxH-FkpFEbEo+JA1bN9R-XWA@mail.gmail.com>
In-Reply-To: <CAD=FV=V4TSKsbjj3dXCdSzVrh3sxH-FkpFEbEo+JA1bN9R-XWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 08/25/2014 05:40 PM, Doug Anderson wrote:
>>
>> I see, so probably until we have a way to define the operating mode for
>> each regulator using DT we should set the opmode to normal when enabling a
>> regulator independently of the value the hardware register reported on probe.
>>
>> Can you please test the following change [0] so I can post as a proper
>> patch? Doug, Mark do you think that forcing the regulator to opmode normal
>> when enabling is the right solution here?
> 
> IMHO that makes sense.
> 

Thanks, I'll post it as a proper patch tomorrow then.

Best regards,
Javier
