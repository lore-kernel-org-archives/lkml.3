Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262Ab3DCWB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 18:01:28 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:44659 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701Ab3DCWB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 18:01:27 -0400
MIME-Version: 1.0
X-Originating-IP: [114.40.16.175]
In-Reply-To: <20130403174208.GL11305@opensource.wolfsonmicro.com>
References: <1364956243.1328.1.camel@phoenix>
	<20130403174208.GL11305@opensource.wolfsonmicro.com>
Date: Thu, 4 Apr 2013 06:01:26 +0800
Message-ID: <CAFRkauBe-jDSv4riPUnfCP9qSm4Pc0ob_JSObJADHoiXYtxnPA@mail.gmail.com>
Subject: Re: [PATCH 1/4] regulator: ab8500: Remove set_voltage_time_sel and
 delay to fix build error
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/4 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Apr 03, 2013 at 10:30:43AM +0800, Axel Lin wrote:
>> The delay field is removed from struct ab8500_regulator_info in commit 29234928
>> "regulator: ab8500: Remove set_voltage_time_sel and delay setting".
>
> I've now finished applying all Lee's outstanding patches (which weren't
> sent to the list...) - could you please recheck if the first two of
> these patches are still revlevant and that the last two are addressed
> properly as per Lee's mails?  Thanks.

Yes, it looks ok now except ab8500_regulator_set_voltage_time_sel() is not
useful because it always return 0.
