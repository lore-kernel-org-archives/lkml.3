Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab3AOJJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 04:09:35 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46351 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab3AOJJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 04:09:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAHp75VegokmDnXTPHYE=kKzwAgiuD9ySg4wRxxZFGkuXdQoStw@mail.gmail.com>
References: <1358173253-680-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==d46_R2btWmi1KnmY-TfAGRxHrwSzT6NFVFP-Hp0-0Kw@mail.gmail.com>
	<CAHp75VdF7twFTFJvUgRZW+jk6cSc_y_DSc4VcCvjBcTYYJGhRQ@mail.gmail.com>
	<CAOh2x=mzcxT=8=RS1Fa_Vn3Frixj9BNEeYGQ0NH+00YV1i-VHw@mail.gmail.com>
	<CAHp75VegokmDnXTPHYE=kKzwAgiuD9ySg4wRxxZFGkuXdQoStw@mail.gmail.com>
Date: Tue, 15 Jan 2013 14:39:33 +0530
Message-ID: <CAKohpomeMb3FYzRTXgWFk8DRN+spgogbW88evM6Xe9xZ9yJ2_w@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: don't exceed AHB master number in dwc_get_data_width
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 January 2013 14:38, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> You forgot the mem2mem type of transfers where we have no information
> about masters except default settings. Otherwise there is the case of
> custom slave config absence when we supply only request line via
> slave_id.

Okay, but even for mem2mem you have just got the right bus width by
selecting same master. But are you programming same masters in control
register? I can't see that :(
