Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaBTHvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:51:03 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48798 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaBTHvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:51:01 -0500
Message-ID: <5305B3E3.6010201@linaro.org>
Date: Thu, 20 Feb 2014 08:50:59 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: timer-keystone: Delete unnecessary variable
References: <52FA1E59.1000307@linaro.org> <1392748168-17080-1-git-send-email-matthias.bgg@gmail.com>
In-Reply-To: <1392748168-17080-1-git-send-email-matthias.bgg@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 07:29 PM, Matthias Brugger wrote:
> Commit 438e0bff5257 added the timer-keystone device driver but make use
> of an unnecessary variable in the init function.
> This patch delets this variable.
>
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>

Applied to my tree for 3.15.

Thanks
   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

