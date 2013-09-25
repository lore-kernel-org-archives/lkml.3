Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab3IYWM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:12:56 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:56387 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3IYWMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:12:55 -0400
Message-ID: <52435FE2.20805@linaro.org>
Date: Thu, 26 Sep 2013 00:12:50 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] cpuidle: avoid unnecessary kzalloc/free of struct
 cpuidle_device_kobj
References: <cover.1379779777.git.viresh.kumar@linaro.org> <fb67ff6fa01bde06aeab43c4a02da2923615e6ef.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <fb67ff6fa01bde06aeab43c4a02da2923615e6ef.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:21 AM, Viresh Kumar wrote:
> We always need to allocate struct cpuidle_device_kobj for all CPUs and so there
> is no real need to have a pointer to it inside struct cpuidle_device.
> 
> This patch makes a object instance of struct cpuidle_device_kobj inside struct
> cpuidle_device instead of a pointer.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

nack, it was made in purpose for kobject_init_and_add.

see commit 728ce22b696f9f1404a74d7b2279a65933553a1b



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

