Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbaE2Ocq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:32:46 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62375 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933467AbaE2Oco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:32:44 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <538744FD.4080709@roeck-us.net>
Date: Thu, 29 May 2014 07:32:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/86] 3.10.41-stable review
References: <20140529043513.451722422@linuxfoundation.org>
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 09:36 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.41 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat May 31 04:34:49 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 143 pass: 134 skipped: 6 fail: 3

Qemu tests all passed.

For reference, failing builds are

unicore32:defconfig		- still fails for all releases
powerpc:ppc64e_defconfig	- fail if built with binutils 2.4; patch pending
powerpc:chroma_defconfig	- fail if built with binutils 2.4; patch pending

Results are as expected. Details are available at http://server.roeck-us.net:8010/builders.

Guenter


