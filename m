Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaINQrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:47:14 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:41147 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaINQrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:47:13 -0400
MIME-Version: 1.0
In-Reply-To: <1409872027.5546.132.camel@x220>
References: <1403167807.23136.31.camel@x220>
	<CAD6h2NRb3tStSy-qiBRQHDo7Yy=Obvgt1hx17M13atXEtTxcaA@mail.gmail.com>
	<1409872027.5546.132.camel@x220>
Date: Mon, 15 Sep 2014 00:47:11 +0800
Message-ID: <CAD6h2NSECE9XUN22oONtzMogKoOEq9us9pzi_y11YPTh=71BJw@mail.gmail.com>
Subject: Re: clk: hisilicon: ARCH_HIP04 and ARCH_HIX5HD2?
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mike Turquette <mturquette@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Haifeng Yan <haifeng.yan@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 September 2014 07:07, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Thu, 2014-06-19 at 17:00 +0800, Haojian Zhuang wrote:
>> On 19 June 2014 16:50, Paul Bolle <pebolle@tiscali.nl> wrote:
>> > 0) Commit d3e6573c48f4 ("clk: hip04: add clock driver") was included in
>> > v3.15. That clock driver is built only if CONFIG_ARCH_HIP04 is set.
>> >
>> > And commit 5efaf09021a5 ("clk: hisi: add clk-hix5hd2.c") was included in
>> > v3.16-rc1. And that driver is built only if CONFIG_ARCH_HIX5HD2 is set.
>> >
>> > 1) Neither the symbol ARCH_HIP04 nor the symbol ARCH_HIX5HD2 is part of
>> > v3.16-rc1. These symbols are also not part of next-20140619. I assume
>> > that both are pending somewhere. Is that correct?
>> >
>> > 2) It would probably be nice if these drivers got some (automatic) build
>> > coverage until those symbols enter the tree. I don't know how that could
>> > be achieved.
>>
>> Because clock driver is the first component should be merged into
>> kernel tree. Otherwise, SoC couldn't be compiled at all since SoC &
>> clock are in two different git tree.
>>
>> I also hope that SoC patches could be merged as soon as possible. But
>> we also need to follow up the comments on SoC patches from mailing
>> list. I can't not say when those SoC patches could be merged into
>> mainline since I'm not the gate keeper. I could only say that we're
>> making effort on this.
>
> ARCH_HIX5HD2 landed in v3.17-rc1, so it left my list of minor worries.
>
> I assume the code to add ARCH_HIP04 is still being worked on. Is that
> correct?
>
>
> Paul Bolle
>

Sorry for late response since I was in trip. Yes, you're right.
ARCH_HIP04 is still working on.

Best Regards
Haojian
