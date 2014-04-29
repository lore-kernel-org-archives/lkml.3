Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060AbaD2EBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:01:31 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62433 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaD2EB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:01:29 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <535F2416.3060809@roeck-us.net>
Date: Mon, 28 Apr 2014 21:01:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 00/94] 3.2.58-rc1 review
References: <lsq.1398647481.453080089@decadent.org.uk>
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2014 06:11 PM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.58 release.
> There are 94 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Apr 30 08:00:00 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 116 pass: 85 skipped: 22 fail: 9

Qemu tests all passed.

There are two new failures, i386:allyesconfig and i386:allmodconfig.

Error in both cases is:

drivers/cpufreq/powernow-k6.c: In function 'powernow_k6_cpu_init':
drivers/cpufreq/powernow-k6.c:218:22: error: 'struct cpufreq_frequency_table' has no member named 'driver_data'

Guenter

