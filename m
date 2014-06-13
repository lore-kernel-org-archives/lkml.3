Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaFMPQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:16:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53210 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaFMPQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:16:10 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <539B15B2.9080205@roeck-us.net>
Date: Fri, 13 Jun 2014 08:16:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/12] 3.15.1-stable review
References: <20140612232044.886466924@linuxfoundation.org>
In-Reply-To: <20140612232044.886466924@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 04:21 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.15.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Jun 14 23:20:28 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 143 pass: 135 skipped: 5 fail: 3
Failed builds:
	powerpc:allmodconfig (binutils 2.23)
	powerpc:allmodconfig (binutils 2.24)
	unicore32:defconfig

Qemu tests all passed.

Results are as expected.
Details are available at http://server.roeck-us.net:8010/builders.

Guenter

