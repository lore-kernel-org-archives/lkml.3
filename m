Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3I3B24 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:28:56 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60117 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3I3B2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:28:54 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5248D3D3.50904@roeck-us.net>
Date: Sun, 29 Sep 2013 18:28:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/71] 3.11.3-stable review
References: <20130929192643.539596256@linuxfoundation.org>
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 12:27 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.11.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Oct  1 19:26:27 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.3-rc1.gz
> and the diffstat can be found below.
>

Build test results:
	total: 110 pass: 108 skipped: 2 fail: 0

Same as with 3.11.2.

qemu:
	arm, microblaze, mips, mips64, ppc, sparc, sparc64, x86, x86_64 pass.
	sh passed with warning (same as with 3.11.2).

Guenter

