Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab3IHHK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 03:10:27 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56040 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3IHHK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 03:10:26 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522C22DB.9080008@roeck-us.net>
Date: Sun, 08 Sep 2013 00:10:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [000/121] 3.2.51-rc1 review
References: <lsq.1378608720.401499712@decadent.org.uk>
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2013 07:52 PM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.51 release.
> There are 121 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Thanks to Guenter Roeck, I've been able to build-test this on a large
> number of architectures and have included a number of build fixes.
>
> Responses should be made by Tue Sep 10 11:00:00 UTC 2013.
> Anything received after that time might be too late.
>
> A combined patch relative to 3.2.50 will be posted as an additional
> response to this.  A shortlog and diffstat can be found below.
>

Pretty good test results. Buildbot says:
	total: 90 pass: 68 skipped: 10 fail: 12
This is down from 22 failures with the initial test run.

If anyone knows how to fix the following problem:

m68k-linux-ld: error: no memory region specified for loadable section `.note.gnu.build-id'

we should be able to get the m68k_nommu builds to work as well.

qemu tests are successful for mips, mips64, ppc, x86, and x86_64.

Details are at http://server.roeck-us.net:8010/builders.

Guenter

