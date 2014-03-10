Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbaCJJf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:35:57 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:62508 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaCJJf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:35:56 -0400
Date: Mon, 10 Mar 2014 09:35:51 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 Resend 2/3] regulator: Add support for S2MPA01
 regulator
Message-ID: <20140310093551.GE14976@lee--X1>
References: <1394100057-32677-1-git-send-email-sachin.kamat@linaro.org>
 <1394100057-32677-2-git-send-email-sachin.kamat@linaro.org>
 <1394102406.25853.4.camel@AMDC1943>
 <CAK9yfHyv+PhLCfy131KCS4GWaAEgQ9qmS5X27bTYHWYUspkYjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9yfHyv+PhLCfy131KCS4GWaAEgQ9qmS5X27bTYHWYUspkYjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Add support for S2MPA01 voltage and current regulator.
> 
> >> +
> >> +struct s2mpa01_info {
> >> +     struct regulator_dev *rdev[S2MPA01_REGULATOR_MAX];
> >
> > Hi,
> >
> > It seems that s2mpa01_info->rdev is not used anywhere, except as return
> > value of devm_regulator_register. I think you can remove it completely.
> 
> Yes. I will send a follow up patch for this.

Let's not break things and fix them up later. Fix it in this patch.

> > Beside that, can this driver be merged into existing s2mps11 regulator
> > driver?
> 
> Haven't analyzed this yet. Will look into the possibility of consolidation
> later.

As above. If consolidation is possible it should be take care of in
the first instance.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
