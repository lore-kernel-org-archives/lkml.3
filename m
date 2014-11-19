Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbaKSJvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:51:10 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53944 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaKSJvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:51:08 -0500
Message-ID: <546C6809.4040304@linaro.org>
Date: Wed, 19 Nov 2014 10:51:05 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Barry Song <21cnbao@gmail.com>, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Yanchang Li <yl22@csr.com>, Barry Song <Baohua.Song@csr.com>
Subject: Re: [PATCH] clocksource: sirf: remove hard-coded clock rate
References: <1415709772-2747-1-git-send-email-21cnbao@gmail.com>
In-Reply-To: <1415709772-2747-1-git-send-email-21cnbao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 01:42 PM, Barry Song wrote:
> From: Yanchang Li <yl22@csr.com>
>
> customers might adjust the whole PLL and dividers according to different
> user scenerios, and this causes the parent clock of sirf clocksource not
> be divided exactly by current hard-coded 1MHz clock rate.
> this patch removes the hard-coded rate and make clocksource drivers more
> adaptive to external changes.
>
> Signed-off-by: Yanchang Li <yl22@csr.com>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>

Patch queued for 3.19

Thanks !

   -- Daniel



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

