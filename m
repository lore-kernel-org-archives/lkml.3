Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605Ab3AQKnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:43:25 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44111 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759531Ab3AQKnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:43:23 -0500
MIME-Version: 1.0
In-Reply-To: <50EEBD8F.6040101@ti.com>
References: <1355996651-17805-1-git-send-email-peter.ujfalusi@ti.com>
	<CACRpkdZK8AA-osijVpbp7U-Wv0XUAVxDPQ3zxfCqWYb6WKjmwQ@mail.gmail.com>
	<50EEBD8F.6040101@ti.com>
Date: Thu, 17 Jan 2013 11:43:22 +0100
Message-ID: <CACRpkdaj5mKk3hy9_QmjcDw3KhZt1Zdx1CXB6ZWmvbhhRWyndA@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: twl4030: Cache the direction and output states
 in private data
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 2:09 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> On 01/10/2013 11:41 AM, Linus Walleij wrote:

>> Sorry Peter this must have been missed somehow.
>>
>> This does not apply to the current v3.8-rc3, could you respin
>> this on top of Torvalds' tree?
>
> Grant applied the patch which this one depends on:
> [1] https://patchwork.kernel.org/patch/1844511/

Hm, it is not in mainline, nor on Grant's "merge" or "next"
branches so it must have fallen on the floor somehow.

I applied both the patches not, thanks!

Linus Walleij
