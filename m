Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab3APQnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:43:08 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:37987 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758391Ab3APQnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:43:05 -0500
MIME-Version: 1.0
In-Reply-To: <1358348555.12502.27.camel@smile>
References: <1358344131-18097-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1358344131-18097-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=nChhB3Bo7CnEZm_86OPBootPd5CqRZ8LCgS5RC4KhMWg@mail.gmail.com>
	<1358348555.12502.27.camel@smile>
Date: Wed, 16 Jan 2013 22:13:02 +0530
X-Google-Sender-Auth: bkehdyuvc44DsYpzNW0IkZ06va0
Message-ID: <CAOh2x=kuETFuQbHq=rAVnKZoUoDTBGf14+awoAu3GVVGkPFqYw@mail.gmail.com>
Subject: Re: [PATCH v3] dw_dmac: don't exceed AHB master number in dwc_get_data_width
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 8:32 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> There a protection of wrong master parameter.
>
> In the code I did
> if ()
> m = ...
> else if ()
> m = ...
>
> Otherwise it would be 0.

That's what. I don't want the else if to be there. Make it else only.
We aren't supposed to pass master other than 0 or 1.
