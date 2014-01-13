Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaAMOGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:06:24 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:36616 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaAMOGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:06:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohponJ5n6Vr56nFJT7nXX5ByOCFHDET7-E_=xsfGK80X3jag@mail.gmail.com>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
	<1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com>
	<CAKohpomA=vSGuKfD-_zwiSnXGkqAQjtiVqxT2Po=D-LDA_FESg@mail.gmail.com>
	<20121216115756.GO14363@n2100.arm.linux.org.uk>
	<20121217054240.GA13300@core.coreip.homeip.net>
	<CAKohponJ5n6Vr56nFJT7nXX5ByOCFHDET7-E_=xsfGK80X3jag@mail.gmail.com>
Date: Mon, 13 Jan 2014 16:06:20 +0200
Message-ID: <CAHp75Ve=G1reCgdgWcor3ChGKk=kFnMxOsfL-U82cWyit7ipgw@mail.gmail.com>
Subject: Re: [PATCH 2/3] CLK: uninline clk_prepare_enable() and clk_disable_unprepare()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry, what is the status of this patchseries? Are you continue to
make it upstream?

On Mon, Apr 8, 2013 at 1:19 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 17 December 2012 11:12, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>> They do not _have_ to be non-inline, I think we should simply drop the
>> first 2 patches and I will refresh and ressend the 3rd one.
>
> I haven't seen this patch since a long time? Any updates?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>



-- 
With Best Regards,
Andy Shevchenko
