Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966013AbaCUA6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:58:41 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:38751 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933939AbaCUA6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:58:36 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.139.5]
In-Reply-To: <20140320154257.GL25092@beef>
References: <1394762274.8460.1.camel@phoenix>
	<1394762428.8460.5.camel@phoenix>
	<20140320154257.GL25092@beef>
Date: Fri, 21 Mar 2014 08:58:34 +0800
Message-ID: <CAFRkauBEinJpBLfXF1itPD5TFiRZj6b66mg3v4mgxSTzSORtOg@mail.gmail.com>
Subject: Re: [PATCH 3/3] regulator: bcm590xx: Use array to save desc and *info
From: Axel Lin <axel.lin@ingics.com>
To: Matt Porter <mporter@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-20 23:42 GMT+08:00 Matt Porter <mporter@linaro.org>:
> On Fri, Mar 14, 2014 at 10:00:28AM +0800, Axel Lin wrote:
>> BCM590XX_NUM_REGS is known in compile time.
>> Use array to save desc and *info makes the code simpler.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>
> Well, ok. It was coded for dynamic allocation because I'm starting to
> work on BCM59054 support, which is similar but different. The actual
> regulators are different but, due to luck, the total number is the
> same between 59056 and 59054...so this can still work for the moment.
> However, another 590xx part does have a different number of regulators
> so I'm not sure this is worth doing when we know we'll go back to
> dynamic allocation in the future.

Then it' ok to keep the code as is, just drop this patch.

Regards,
Axel
