Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaBTHYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:24:22 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58191 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbaBTHYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:24:19 -0500
Message-ID: <5305AD7D.1060702@linaro.org>
Date: Thu, 20 Feb 2014 15:23:41 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [sched/balance] WARNING: CPU: 0 PID: 8 at kernel/sched/core.c:2939
 rt_mutex_setprio()
References: <20140219121855.GF7241@localhost>
In-Reply-To: <20140219121855.GF7241@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 08:18 PM, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is

[snip]
> 
>     sched/balance: add balance_interval to tuning top level balance frequency
>     

Good catching! :)
I will fix this problem and updated soon.

-- 
Thanks
    Alex
