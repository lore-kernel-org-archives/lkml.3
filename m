Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbaJ1JQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:16:30 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19394 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbaJ1JQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:16:27 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-2a-544f5ee8af7a
Message-id: <1414487782.24949.23.camel@AMDC1943>
Subject: Re: [PATCH v2 4/5] power: max77693: Add charger driver for Maxim 77693
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-api@vger.kernel.org,
        devicetree@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Tue, 28 Oct 2014 10:16:22 +0100
In-reply-to: <20141027185656.GB18965@earth.universe>
References: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
 <1413808489-3524-5-git-send-email-k.kozlowski@samsung.com>
 <20141027185656.GB18965@earth.universe>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/xy7ov4vxDDM6+U7PYOGM9q8WkJ++Z
	LeYfOcdqMXHlZGaLs01v2C3ufz3KaLH5ewebxeVdc9gsPvceYbRYe+Quu8XpblaL07tLHHg8
	ds66y+6xeYWWx6ZVnWwed67tYfOYdzLQo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDKOzpQt
	aOasOLGOp4FxLnsXIyeHhICJxP/jt9ggbDGJC/fWA9lcHEICSxklvv3fwQjhfGaUmHC9HayD
	V8BAonPWR7AOYQF/idfLD7GC2GwCxhKbly8Bi4sIqEm8v/SUBaSZWWAVs0Tb616gSRwcLAKq
	Eov7DEFqOIE2zz65kQViwVpGiSl/Z7OAJJgF1CUmzVvEDFIvIaAs0djvBrFXUOLH5HtQJfIS
	m9e8ZZ7AKDALSccsJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESIV93MC49
	ZnWIUYCDUYmHN4LFP0SINbGsuDL3EKMEB7OSCG9EDFCINyWxsiq1KD++qDQntfgQIxMHp1QD
	o2a//Z3V8bcs5FabNqxs+Ry58wPL32RrMbvtD04op1UFXj1d6fRUl0FkofH9IL7J69I6/O5Y
	JdcqvVl570mRckGGzYlk8R9d3quSql2fLPfOemI8yXiB5/RZL0P9HDOyzY+o3PjgMO38em5m
	lzvRBsx3j3ls/eLAdEQoQzVY8v0jiZlX10/SVmIpzkg01GIuKk4EANvp5xtuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On pon, 2014-10-27 at 19:56 +0100, Sebastian Reichel wrote:
> Hi,
> 
> On Mon, Oct 20, 2014 at 02:34:48PM +0200, Krzysztof Kozlowski wrote:
> > Add new driver for Maxim 77693 switch-mode charger (part of max77693
> > MFD driver) providing power supply class information to userspace.
> > 
> > The charger has +20V tolerant input. Current input can be set from 0 to
> > 2.58 A. The charger can deliver up to 2.1 A to the battery or 3.5 A to
> > the system (when supplying additional current from battery to system).
> > 
> > The driver is configured through DTS (battery and system related
> > settings) and sysfs entries (timers and top-off charging threshold).
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> I guess it makes sense to queue this together with the mfd parts.
> 
> Acked-By: Sebastian Reichel <sre@kernel.org>

Thank you. Could you also look at documentation change, patch 5/5:
Documentation: charger: max77693: Document exported sysfs entry
https://lkml.org/lkml/2014/10/20/232

I think that one also needs your ack as this is power supply related
ABI.

Best regards,
Krzysztof


