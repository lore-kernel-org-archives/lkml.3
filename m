Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbaJ2Kvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:51:54 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60039 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaJ2Kvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:51:52 -0400
Message-ID: <5450C6C2.2050506@collabora.co.uk>
Date: Wed, 29 Oct 2014 11:51:46 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v5 3/4] regulator: max77686: Add suspend disable for some
 LDOs
References: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com> <1414411911-5539-4-git-send-email-k.kozlowski@samsung.com> <20141028223121.GH18557@sirena.org.uk> <1414574413.18868.6.camel@AMDC1943> <20141029100142.GR18557@sirena.org.uk> <1414577934.18868.7.camel@AMDC1943> <20141029103140.GY18557@sirena.org.uk> <1414579442.18868.13.camel@AMDC1943>
In-Reply-To: <1414579442.18868.13.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/29/2014 11:44 AM, Krzysztof Kozlowski wrote:
> On śro, 2014-10-29 at 10:31 +0000, Mark Brown wrote:
>> On Wed, Oct 29, 2014 at 11:18:54AM +0100, Krzysztof Kozlowski wrote:
>> > On śro, 2014-10-29 at 10:01 +0000, Mark Brown wrote:
>> 
>> > > No, this isn't suspend enable control - this is normal, standard enable
>> > > control and the device has no suspend enable control.
>> 
>> > You mean that for such regulator the driver shouldn't implement
>> > suspend_enable()?
>> 
>> Yes, if there is no separate control of suspend mode in hardware then of
>> course the driver shouldn't implement operations for things it doesn't
>> have.
> 
> Oh, thanks! I'll send fixed patch.
> 
> This means that probably the max77802 ("mirrored" driver) should be
> fixed...
> 

Indeed, I had the same confusion that you had. Just to avoid duplicating work,
do you want me to send a fix or are you going to include one on your series?

> Best regards,
> Krzysztof
> 
> 

Best regards,
Javier
