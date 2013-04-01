Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab3DAFtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 01:49:03 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:61158 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab3DAFtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 01:49:01 -0400
Date: Sun, 31 Mar 2013 22:45:03 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 1/1] sbs-battery: Use of_match_ptr() macro
Message-ID: <20130401054502.GA25376@lizard>
References: <1363256386-28552-1-git-send-email-sachin.kamat@linaro.org>
 <CAK9yfHxFVb=ziKt5EPyFM6PSZqxGm4gYEFHBN1t1Yx=GOkUFtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAK9yfHxFVb=ziKt5EPyFM6PSZqxGm4gYEFHBN1t1Yx=GOkUFtg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 09:02:28AM +0530, Sachin Kamat wrote:
[...]
> > -               .of_match_table = sbs_dt_ids,
> > +               .of_match_table = of_match_ptr(sbs_dt_ids),
> >         },
> >  };
> >  module_i2c_driver(sbs_battery_driver);
> > --
> > 1.7.4.1
>
> ping...

Applied, thanks!

Anton
