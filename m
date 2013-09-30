Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3I3B1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:27:33 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56455 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3I3B1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:27:31 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5248D37F.7060808@roeck-us.net>
Date: Sun, 29 Sep 2013 18:27:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/49] 3.10.14-stable review
References: <20130929191603.008825488@linuxfoundation.org>
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 12:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.14 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Oct  1 19:15:49 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.14-rc1.gz
> and the diffstat can be found below.
>

Build test results:
	total: 110 pass: 110

Same as with 3.10.13.

qemu:
	arm, microblaze, mips, mips64, ppc, sparc, sparc64, x86, x86_64 pass.
	sh passes with warning (same as with 3.10.13).

Guenter

