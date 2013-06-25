Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3FYMBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:01:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60114 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab3FYMBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:01:14 -0400
Message-ID: <51C9867C.80206@ti.com>
Date: Tue, 25 Jun 2013 07:01:00 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <benoit.cousson@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2] ARM: DTS: OMAP4: Add OMAP4 Blaze Tablet support
References: <1372159970-6361-1-git-send-email-ruslan.bilovol@ti.com>
In-Reply-To: <1372159970-6361-1-git-send-email-ruslan.bilovol@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 06:32 AM, Ruslan Bilovol wrote:
> The OMAP4 Blaze Tablet is TI OMAP4 processor-based
> development platform in a tablet formfactor.
> The platform contains many of the features found in
> present-day handsets (such as audio, video, wireless
> functions and user interfaces) and in addition
> contains features for software development and test.
>
> This patch adds initial support for the OMAP4 Blaze
> Tablet development platform. Additional functionality
> depends on different drivers and code modifications that
> are not upstreamed yet or do not support DT yet, so will
> be added later.

http://svtronics.com/omap/sevm4460,blaze,omap might help too :)
[...]
> +
> +#include "twl6030.dtsi"
> +
Might be good to see the TWL interrupt pin information made available as 
well?
[...]

Regards,
Nishanth Menon
