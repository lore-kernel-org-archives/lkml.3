Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3AQNpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:45:13 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33309 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab3AQNpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:45:12 -0500
Message-ID: <50F80063.5080803@ti.com>
Date: Thu, 17 Jan 2013 14:45:07 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3] gpio: twl4030: Cache the direction and output states
 in private data
References: <1355996651-17805-1-git-send-email-peter.ujfalusi@ti.com> <CACRpkdZK8AA-osijVpbp7U-Wv0XUAVxDPQ3zxfCqWYb6WKjmwQ@mail.gmail.com> <50EEBD8F.6040101@ti.com> <CACRpkdaj5mKk3hy9_QmjcDw3KhZt1Zdx1CXB6ZWmvbhhRWyndA@mail.gmail.com>
In-Reply-To: <CACRpkdaj5mKk3hy9_QmjcDw3KhZt1Zdx1CXB6ZWmvbhhRWyndA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 01/17/2013 11:43 AM, Linus Walleij wrote:
> On Thu, Jan 10, 2013 at 2:09 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>> On 01/10/2013 11:41 AM, Linus Walleij wrote:
> 
>>> Sorry Peter this must have been missed somehow.
>>>
>>> This does not apply to the current v3.8-rc3, could you respin
>>> this on top of Torvalds' tree?
>>
>> Grant applied the patch which this one depends on:
>> [1] https://patchwork.kernel.org/patch/1844511/
> 
> Hm, it is not in mainline, nor on Grant's "merge" or "next"
> branches so it must have fallen on the floor somehow.
> 
> I applied both the patches not, thanks!

Thank you, I was planning to go through my pending patches tomorrow and resend
or annoy maintainers with them.

Thanks again,
Péter
