Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbaHFCdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 22:33:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56121 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbaHFCdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 22:33:36 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E193FA.8070601@roeck-us.net>
Date: Tue, 05 Aug 2014 19:33:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/19] 3.4.102-stable review
References: <20140805182934.022406678@linuxfoundation.org>
In-Reply-To: <20140805182934.022406678@linuxfoundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 11:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.102 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug  7 18:29:24 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 119 pass: 113 fail: 6
Failed builds:
	alpha:allmodconfig
	arm:s5pv210_defconfig
	score:defconfig
	sparc64:allmodconfig
	unicore32:defconfig
	xtensa:allmodconfig

Qemu tests all passed.

Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

