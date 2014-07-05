Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbaGEFsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 01:48:06 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51545 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaGEFsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 01:48:04 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53B79192.8020104@roeck-us.net>
Date: Fri, 04 Jul 2014 22:48:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/66] 3.15.4-stable review
References: <20140704221422.813435485@linuxfoundation.org>
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2014 03:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.15.4 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Jul  6 22:13:57 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 144 pass: 136 skipped: 5 fail: 3
Failed builds:
	powerpc:allmodconfig (binutils 2.23)
	powerpc:allmodconfig (binutils 2.24)
	unicore32:defconfig

Qemu tests all passed.

Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

On a side note, would be great if you can update the master branch
of -stable at some point. It is still at -rc2.

Thanks,
Guenter

