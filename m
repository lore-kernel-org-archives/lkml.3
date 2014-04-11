Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaDKVts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:49:48 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59069 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaDKVtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:49:46 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53486376.9020604@roeck-us.net>
Date: Fri, 11 Apr 2014 14:49:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.14 00/23] 3.14.1-stable review
References: <20140411161200.236939691@linuxfoundation.org>
In-Reply-To: <20140411161200.236939691@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 09:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.1 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Apr 13 16:11:46 UTC 2014.
> Anything received after that time might be too late.

Build results:
     total: 126 pass: 121 skipped: 4 fail: 1

Failing build is powerpc:allmodconfig. Error log:

arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:1312: Error: attempt to move .org backwards
make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1

Qemu tests all passed. Results match the build results from 3.14, and are
therefore as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

