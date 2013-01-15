Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3AOJgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 04:36:15 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:60412 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3AOJgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 04:36:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpomeMb3FYzRTXgWFk8DRN+spgogbW88evM6Xe9xZ9yJ2_w@mail.gmail.com>
References: <1358173253-680-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==d46_R2btWmi1KnmY-TfAGRxHrwSzT6NFVFP-Hp0-0Kw@mail.gmail.com>
	<CAHp75VdF7twFTFJvUgRZW+jk6cSc_y_DSc4VcCvjBcTYYJGhRQ@mail.gmail.com>
	<CAOh2x=mzcxT=8=RS1Fa_Vn3Frixj9BNEeYGQ0NH+00YV1i-VHw@mail.gmail.com>
	<CAHp75VegokmDnXTPHYE=kKzwAgiuD9ySg4wRxxZFGkuXdQoStw@mail.gmail.com>
	<CAKohpomeMb3FYzRTXgWFk8DRN+spgogbW88evM6Xe9xZ9yJ2_w@mail.gmail.com>
Date: Tue, 15 Jan 2013 11:36:11 +0200
Message-ID: <CAHp75Vee+2PTzxnd0zQ1zeR437uKj_bRV-Pbb5g7O+CfaUb2aw@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: don't exceed AHB master number in dwc_get_data_width
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 11:09 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 15 January 2013 14:38, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
>> You forgot the mem2mem type of transfers where we have no information
>> about masters except default settings. Otherwise there is the case of
>> custom slave config absence when we supply only request line via
>> slave_id.
>
> Okay, but even for mem2mem you have just got the right bus width by
> selecting same master. But are you programming same masters in control
> register? I can't see that :(

Oops. Seems this patch does not cover the CTL lo register value.
Thank you for pointing this out. I will think how to make the fix better.

-- 
With Best Regards,
Andy Shevchenko
