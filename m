Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbaBKUEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:04:37 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41516 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaBKUEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:04:32 -0500
Message-ID: <52FA8245.5050707@gmail.com>
Date: Tue, 11 Feb 2014 21:04:21 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>
CC: Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@gmail.com>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH v2 1/5] drivers: of: add initialization code for reserved
 memory
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com>	 < 1391515773-6112-2-git-send-email-m.szyprowski@samsung.com>	 <20140205110538. 99E47C40A89@trevor.secretlab.ca>	 <52FA0D6E.9090304@samsung.com>	 < 20140211121316.24032C40C4D@trevor.secretlab.ca>	 <52FA33E2.4050004@samsung. com>	 <20140211190104.7E6C5C4140E@trevor.secretlab.ca> <1392148971.3835.15.camel@pasglop>
In-Reply-To: <1392148971.3835.15.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11.02.2014 21:02, Benjamin Herrenschmidt wrote:
> On Tue, 2014-02-11 at 19:01 +0000, Grant Likely wrote:
>
>>> except that the former IMHO better suits the definition of memory
>>> region, which I see as a single contiguous range of memory and can be
>>> simplified to have a single reg entry per region.
>>
>> My point is rather if multiple reg tuples are found in a reserved memory
>> node, the kernel must respect them and reserve the memory. I'm not
>> arguing about whether or not that makes for a good binding.
>
> agreed.

My point is why, if the binding defines that just a single tuple should 
be provided.

Best regards,
Tomasz
