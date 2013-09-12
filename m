Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab3ILWhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:37:18 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60505 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3ILWhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:37:15 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52324216.30503@roeck-us.net>
Date: Thu, 12 Sep 2013 15:37:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/16] 3.11.1-stable review
References: <20130912181156.173326121@linuxfoundation.org>
In-Reply-To: <20130912181156.173326121@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 11:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.11.1 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Sep 14 18:10:15 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.1-rc1.gz
> and the diffstat can be found below.
>

Test results:
	total: 110 pass: 107 skipped: 2 fail: 1

The failure is xtensa:allmodconfig. A patch fixing the problem has been submitted,
but is not yet available upstream.

qemu:
	arm, microblaze, mips, mips64, ppc, x86, x86_64 all pass.
	sh passed with warning.

qemu:sh is new and only passes because of a patch I had to add to fix qemu,
so don't try it yourself. It also does create a backtrace due to a known
problem for which a patch has been submitted but is not yet available
upstream.

Details are at http://server.roeck-us.net:8010/builders.

Guenter


