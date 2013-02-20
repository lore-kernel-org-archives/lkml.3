Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934971Ab3BTLGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:06:03 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:37126 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758869Ab3BTLGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:06:00 -0500
MIME-Version: 1.0
In-Reply-To: <201302201006.41287.arnd@arndb.de>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru>
	<1361271268.592027245@f310.mail.ru>
	<1361338882.986089809@f173.mail.ru>
	<201302201006.41287.arnd@arndb.de>
Date: Wed, 20 Feb 2013 19:05:59 +0800
Message-ID: <CAP1dx+xj3+PVu98pRBAOhLxvOzhwE7VNShMLmqk-jy_CgXh8GA@mail.gmail.com>
Subject: Re: Re[8]: [PATCH v3] mfd: syscon: Add non-DT support
From: Dong Aisheng <dong.aisheng@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 February 2013 18:06, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 20 February 2013, Alexander Shiyan wrote:
>> On 20 February 2013 13:41, Alexander Shiyan <shc_work@mail.ru> wrote:
>> >
>> > One problem is that every user needs to add their syscon compatible device
>> > support(platform_device_id) in syscon driver first before they can use it.
>> > But it looks to me just like how other driver generally does.
>>
>> I agree, this is a more proper way, but in this case we should create a big table
>> here with records for each device...
>>
>> > Arnd,
>> > Do you think this is an issue?
>
> I would first like to get an answer to the question I asked in my first mail,
> which is what the use case of non-DT support in this driver is. If this
> is used only by a new platform that has to use DT anyway, or by an existing
> platform that is easy enough to convert, we probably shouldn't do all this
> at all.
>

If the platform can convert to dt, then we do not have such issue.
The question is do we allow the existing non-dt platforms to use it
before converting?

Regards
Dong Aisheng
