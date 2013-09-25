Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3IYEfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 00:35:41 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54649 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab3IYEff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 00:35:35 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5242680F.6020305@roeck-us.net>
Date: Tue, 24 Sep 2013 21:35:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/40] 3.4.63-stable review
References: <20130925001041.939335518@linuxfoundation.org>
In-Reply-To: <20130925001041.939335518@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 05:11 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.63 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Sep 27 00:09:16 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.63-rc1.gz
> and the diffstat can be found below.
>

Build test results:
	total: 103 pass: 89 skipped: 10 fail: 4

qemu:
	microblaze, mips, mips64, ppc, sh, sparc, x86, x86_64 pass.
	arm, sparc64 skipped

Same results as with 3.4.62.

---

The summary e-mail for 3.0.97 is not (or not yet) on lkml, so I'll provide the results here.

Build test results:
	total: 98 pass: 71 skipped: 16 fail: 11

qemu:
	ppc, sh, sparc, x86, x86_64 passed
	arm, microblaze, mips, mips64, sparc64 skipped

Same results as with 3.0.96.

I forgot to mention that qemu:sparc and qemu:sparc64 are new tests for all versions.

Guenter

