Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbaCNRVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:21:35 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:34834 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbaCNRVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:21:34 -0400
MIME-Version: 1.0
In-Reply-To: <1394796535.28803.250.camel@smile.fi.intel.com>
References: <1394820159-562-1-git-send-email-chiau.ee.chew@intel.com>
	<1394796535.28803.250.camel@smile.fi.intel.com>
Date: Fri, 14 Mar 2014 22:51:33 +0530
X-Google-Sender-Auth: WxNjqRonzc4y4Od8JJZhJMUtqJY
Message-ID: <CAOh2x=kSjuh+=kmAy9E5v7va9UhZGsv_1iqwm1NhuOev=+c=Cw@mail.gmail.com>
Subject: Re: [PATCH v2] dma: dw: Add suspend and resume handling for PCI mode DW_DMAC.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Chew Chiau Ee <chiau.ee.chew@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lim Lee Booi <lee.booi.lim@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 4:58 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Sat, 2014-03-15 at 02:02 +0800, Chew Chiau Ee wrote:
>> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
>>
>> This is to disable/enable DW_DMAC hw during late suspend/early resume.
>> Since DMA is providing service to other clients (eg: SPI, HSUART),
>> we need to ensure DMA suspends after the clients and resume
>> before the clients are active.
>
> Thanks for an update!
>
> Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

> P.S. It seems a material is for v3.16?

I think it can go in 3.15 as well.. we aren't that late yet.
