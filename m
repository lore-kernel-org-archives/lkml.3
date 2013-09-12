Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab3ILW3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:29:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51346 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3ILW3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:29:09 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52324031.7090003@roeck-us.net>
Date: Thu, 12 Sep 2013 15:29:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/19] 3.0.96-stable review
References: <20130912172524.135620246@linuxfoundation.org>
In-Reply-To: <20130912172524.135620246@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 10:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.96 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Sep 14 17:24:38 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.96-rc1.gz
> and the diffstat can be found below.
>

Build results:
	total: 98 pass: 71 skipped: 16 fail: 11

qemu:
	ppc, sh, x86, x86_64 passed
	arm, microblaze, mips, mips64 skipped

More builds than last time (crisv32 and several arm builds are new), fewer build failures
thanks to ben Hutchings who tracked down some of the problems still causing build failures.
qemu:sh test is also new.

Details are at http://server.roeck-us.net:8010/builders.

Guenter

