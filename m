Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbaGHNTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:19:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60818 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbaGHNTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:19:42 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BBEFE9.7030508@roeck-us.net>
Date: Tue, 08 Jul 2014 06:19:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/53] 3.10.48-stable review
References: <20140707235829.281783607@linuxfoundation.org>
In-Reply-To: <20140707235829.281783607@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 04:57 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.48 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jul  9 23:58:20 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 138 pass: 137 fail: 1
Failed builds:
	score:defconfig

Qemu tests all passed.

This is an improvement over 3.10.47, as the unicore32 build now passes.

Details are available at http://server.roeck-us.net:8010/builders.

The following patches would fix the remaining build failure.

ae49b83dca score: normalize global variables exported by vmlinux.lds
1ed62ca648 Score: Implement the function csum_ipv6_magic
5fbbf8a1a9 Score: The commit is for compiling successfully
df9e4d1c39 Score: Modify the Makefile of Score, remove -mlong-calls for compiling

Guenter

