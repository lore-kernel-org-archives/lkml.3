Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3CEHJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:09:55 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:38982 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3CEHJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:09:53 -0500
MIME-Version: 1.0
X-Originating-IP: [114.34.49.216]
In-Reply-To: <20130305070339.GE9391@opensource.wolfsonmicro.com>
References: <1362464160.1111.1.camel@phoenix>
	<20130305070339.GE9391@opensource.wolfsonmicro.com>
Date: Tue, 5 Mar 2013 15:09:51 +0800
Message-ID: <CAFRkauDJbEZCn-qdnv_WzQSV=zDfR369YcDX19pbkAu2c4bxfQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] regulator: core: Add enable_is_inverted flag
 to indicate set enable_mask bits to disable
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "Jett.Zhou" <jtzhou@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/5 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Tue, Mar 05, 2013 at 02:16:00PM +0800, Axel Lin wrote:
>> Add enable_is_inverted flag to indicate set enable_mask bits to disable
>> when using regulator_enable_regmap and friends APIs.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>> Reviewed-by: Haojian Zhuang <haojian.zhuang@gmail.com>
>> ---
>> This patch was sent on https://lkml.org/lkml/2013/2/16/14.
>> This resend is against linux-next tree (20130305).
>
> This doesn't apply against v3.9-rc1...  what are the dependencies?

I think it is because of commit 5838b032fd
"regulator: core: update kernel documentation for regulator_desc".

I found the patch (sent on https://lkml.org/lkml/2013/2/16/14 ) does not apply
to today's linux-next tree. So I re-generate the patchs against linux-next.

Should I resend the previous version of this patch?

Axel
