Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058AbaDIEZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 00:25:21 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:43240 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaDIEZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 00:25:19 -0400
MIME-Version: 1.0
In-Reply-To: <5344A0A3.9030909@intel.com>
References: <5343740C.9010609@intel.com>
	<CAKohpomRb1pix3zQWeY0mKkfuikUtR6w+PUOTzQV_hngPrpHRw@mail.gmail.com>
	<5344A0A3.9030909@intel.com>
Date: Wed, 9 Apr 2014 09:55:18 +0530
Message-ID: <CAKohpo=t2Bb7EO3J36i9iRn_nHbtPvwzBpswVSb8xQXT7kk03g@mail.gmail.com>
Subject: Re: [clocksource] INFO: possible irq lock inversion dependency detected
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jet Chen <jet.chen@intel.com>
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2014 06:51, Jet Chen <jet.chen@intel.com> wrote:
> spin_lock_irqsave() does fix this issue.
>
> Tested-by: Jet Chen <jet.chen@intel.com>

Thanks a lot :)

How did you got this in cc list ?

"abd38155f8293923de5953cc063f9e2d7ecb3f04.1396679170.git.viresh.kumar@linaro.org"
<abd38155f8293923de5953cc063f9e2d7ecb3f04.1396679170.git.viresh.kumar@linaro.org>
