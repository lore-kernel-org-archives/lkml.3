Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab3IBOyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 10:54:25 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:62792 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526Ab3IBOyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 10:54:24 -0400
Message-ID: <5224A69C.9000600@linaro.org>
Date: Mon, 02 Sep 2013 16:54:20 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ARM/ARM64 architected timer updates for v3.12, take
 2
References: <5220CDD8.6090903@arm.com>
In-Reply-To: <5220CDD8.6090903@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 06:52 PM, Sudeep KarkadaNagesha wrote:
> git://linux-arm.org/linux-skn.git timer_evtstrm

Hi Sudeep,

I don't see the acked-by from Olof or Kevin.

Your patchset touches files under arch/arm which are maintained by them
and I won't take the patchset if they don't agree the modifications on
the files falling under my umbrella that will pass through my tree.

Please do it ASAP if you want a chance to hit 3.12, it is already very late.

Thanks
  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

