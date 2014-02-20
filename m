Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbaBTNN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:13:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39756 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbaBTNNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:13:25 -0500
Message-ID: <5305FF70.2030406@canonical.com>
Date: Thu, 20 Feb 2014 14:13:20 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [x86] 339a3922f6: +4.3% aim7 jobs-per-min
References: <20140220130646.GA22815@localhost>
In-Reply-To: <20140220130646.GA22815@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 20-02-14 14:06, Fengguang Wu schreef:
> Hi Maarten,
>
> We are glad to find that your commit 339a3922f68dcb7d93001f07b7e914d5cf6c066d
> ("decrease useless padding") increased aim disk_src performance by 4.3%:
>
> 74833276be6802b  339a3922f68dcb7d93001f07b
> ---------------  -------------------------
>      511685 ~ 0%      +4.3%     533571 ~ 0%  TOTAL aim7.2000.jobs-per-min
>       77.30 ~ 0%      -9.9%      69.66 ~ 0%  TOTAL time.system_time
>        1.95 ~ 2%      +7.0%       2.09 ~ 2%  TOTAL iostat.sda.rrqm/s
>       23.57 ~ 0%      -4.1%      22.60 ~ 0%  TOTAL time.elapsed_time
>         425 ~ 0%      -3.1%        412 ~ 0%  TOTAL time.percent_of_cpu_this_job_got
>        7.59 ~ 0%      -2.9%       7.37 ~ 0%  TOTAL boottime.dhcp
>       15.24 ~ 0%      -1.9%      14.94 ~ 0%  TOTAL boottime.boot
>
Really? I just did it to get rid of the 15-byte nop sequences with tons of prefixes.
Interesting..

~Maarten

