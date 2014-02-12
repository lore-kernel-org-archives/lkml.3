Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaBLJZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:25:43 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39674 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbaBLJZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:25:41 -0500
Date: Wed, 12 Feb 2014 09:25:29 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/3] of: functions to count number of elements and
 convert regulators
Message-ID: <20140212092528.GA21992@e106331-lin.cambridge.arm.com>
References: <2573561.oCYNnnL0gm@phil>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2573561.oCYNnnL0gm@phil>
Thread-Topic: [PATCH 0/3] of: functions to count number of elements and
 convert regulators
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Tue, Feb 11, 2014 at 11:59:25PM +0000, Heiko Stübner wrote:
> In a different thread [0] Mark Rutland suggested that drivers should not
> repeatedly open-code the counting of array elements in a property as well
> as handling the format and endianes of the DTB, as these should be limited
> to the of_ helper functions.
> 
> Therefore the first patch introduces a set of helper functions for counting
> the number of u8,...,u64 elements in a property.
> 
> The second and third patch convert the two regulator drivers that use this
> pattern to instead use both of_property_count_u32_elemens as well as
> of_property_read_u32_index.
> 
> gpio-regulator change tested on a s3c2416-based device, ti-abb-regulator
> compile-tested only.

Cheers for this. All the patches look fine to me, so for the series:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.
