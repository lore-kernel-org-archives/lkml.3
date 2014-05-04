Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaEDRTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 13:19:33 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55124 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaEDRTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 13:19:31 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5366769D.2010104@roeck-us.net>
Date: Sun, 04 May 2014 10:19:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/158] 3.14.3-stable review
References: <20140504154029.975081050@linuxfoundation.org>
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 08:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.3 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue May  6 15:38:47 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 127 pass: 121 skipped: 4 fail: 2

Qemu tests all passed.

Additional failure is from new build target unicore32:defconfig, which fails
in all releases. The second failure is powerpc:allmodconfig which, together
with powerpc:allyesconfig, fails to build in 3.14 and later kernels.
Results are therefore as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

