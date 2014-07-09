Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaGIDNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:13:53 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61660 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaGIDNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:13:52 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BCB36E.1030803@roeck-us.net>
Date: Tue, 08 Jul 2014 20:13:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 000/125] 3.2.61-rc1 review
References: <lsq.1404846109.699842714@decadent.org.uk>
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 12:01 PM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.61 release.
> There are 125 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jul 10 19:01:49 UTC 2014.
> Anything received after that time might be too late.
>

Looks better now, with the additional fix.

Build results:
	total: 109 pass: 100 fail: 9
Failed builds:
	alpha:allmodconfig
	microblaze:mmu_defconfig
	microblaze:nommu_defconfig
	mips:allmodconfig
	score:defconfig
	sparc64:allmodconfig
	unicore32:defconfig
	xtensa:defconfig
	xtensa:allmodconfig

Qemu tests all passed.

Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

