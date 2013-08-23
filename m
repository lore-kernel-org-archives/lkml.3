Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3HWXBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 19:01:04 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:62433 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3HWXBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 19:01:02 -0400
Message-ID: <5217E9A5.8030503@gmail.com>
Date: Sat, 24 Aug 2013 01:00:53 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        jiada_wang@mentor.com, robherring2@gmail.com, grant.likely@linaro.org,
        broonie@kernel.org, vapier@gentoo.org, ralf@linux-mips.org,
        kyungmin.park@samsung.com, shawn.guo@linaro.org,
        sebastian.hesselbarth@gmail.com, LW@KARO-electronics.de,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 2/4] clk: implement clk_unregister
References: <1377020063-30213-1-git-send-email-s.nawrocki@samsung.com> <1377020063-30213-3-git-send-email-s.nawrocki@samsung.com> <20130823215838.8231.21635@quantum>
In-Reply-To: <20130823215838.8231.21635@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 11:58 PM, Mike Turquette wrote:
>> +static void clk_nodrv_disable_unprepare(struct clk_hw *hw)
>> >  +{
>> >  +       WARN_ON(1);
>
> Ideally we shouldn't get here, but if we do I guess it could be very
> noisy. How about WARN_ONCE?

Yes, I guess that would be much better. I could resend it tomorrow if 
needed.

> After you address Russell's comments in patch #1 I will be happy to take
> this series.

I have posted today v3 addressing Russell's comments. Hopefully patch #3
(the patches got reordered) looks OK now. v3 includes actual assigning
of clk->owner I somehow managed to miss in previous series :/ Please have
a look at it.

--
Regards,
Sylwester
