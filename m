Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaJWJ1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 05:27:44 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52057 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaJWJ1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 05:27:41 -0400
References: <1413816472-1895-1-git-send-email-javier.martinez@collabora.co.uk> <1413816472-1895-5-git-send-email-javier.martinez@collabora.co.uk> <20141022164813.GD2344@sirena.org.uk>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20141022164813.GD2344@sirena.org.uk>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <0DA944C5-7A6B-461B-A8E6-D47343D22E0B@collabora.co.uk>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
X-Mailer: iPhone Mail (11D257)
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v3 4/5] regulator: max77802: Parse regulator operating mode properties
Date: Thu, 23 Oct 2014 11:28:09 +0200
To: Mark Brown <broonie@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

> On 22/10/2014, at 18:48, Mark Brown <broonie@kernel.org> wrote:
> 
>> On Mon, Oct 20, 2014 at 04:47:51PM +0200, Javier Martinez Canillas wrote:
>> 
>> +    char *states[PM_SUSPEND_MAX + 1] = {
>> +        [PM_SUSPEND_MEM] = "regulator-state-mem",
>> +        [PM_SUSPEND_MAX] = "regulator-state-disk",
>> +    };
> 
> This still has the same problem as your previous patch with things not
> being as joined up with the core as they should be.  What I'd like to
> see is that the code to extract the number for each state is in the core
> and then the drivers just provide a translation function to map from
> this to the internal modes.

Ok, I'll send a new version parsing it in the core and providing a translation function in the driver as you said.

However this is an implementation detail and should not change the DT bindings in the current version. Could you please let me know if you have any issues with the other patches from this series so I can address all of them when doing a re-spin?

Thanks a lot and best regards,
Javier