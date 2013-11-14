Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab3KNB35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:29:57 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:62896 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3KNB3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:29:49 -0500
MIME-Version: 1.0
In-Reply-To: <20131113135021.GN878@sirena.org.uk>
References: <1383923118-26921-1-git-send-email-k.kozlowski@samsung.com>
	<1384263715-5713-1-git-send-email-k.kozlowski@samsung.com>
	<20131113135021.GN878@sirena.org.uk>
Date: Thu, 14 Nov 2013 10:29:49 +0900
X-Google-Sender-Auth: sF8W3bG7bgVkQG2EauJEnqwVLHg
Message-ID: <CAH9JG2W+sjxL7gxvHJ8wXaDWE+KtKbpxdrhMLtF_ZTVS_VQ+CQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: s5m8767: Disable OVCB in probe
From: Kyungmin Park <kmpark@infradead.org>
To: Mark Brown <broonie@kernel.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 10:50 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Nov 12, 2013 at 02:41:55PM +0100, Krzysztof Kozlowski wrote:
>> According to SW Guide the Over-Voltage Clamp may malfunction at VBatt
>> 5.25V and 110'C temperature. This may result in overshooting or
>> undershooting LDO's voltage outputs.
>> Disable the Over-Voltage Clamp in probe by updating proper bit in all
>> LDO registers.
>
> Is there no way to detect these conditions at runtime?  The temperature
> condition in particular seems very high and hence relatively unlikely to
> hold most of the time, disabling the overvoltage protection all the time
> seems like an uncertain tradeoff.

It's hard to do at runtime. right it's rare case. but some condition
(as above) is meet, and no code as workaround. it's mal-function.
that's the guide to avoid this mal-functions.

Thank you,
Kyungmin Park
