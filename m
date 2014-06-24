Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaFXX14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:27:56 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58272 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaFXX1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:27:54 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53AA096F.6080000@roeck-us.net>
Date: Tue, 24 Jun 2014 16:27:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/52] 3.10.45-stable review
References: <20140624154713.428945460@linuxfoundation.org>
In-Reply-To: <20140624154713.428945460@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 08:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.45 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jun 26 15:46:59 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 144 pass: 136 skipped: 6 fail: 2
Failed builds:
	score:defconfig
	unicore32:defconfig

Qemu tests all passed.

Results are as expected. As mentioned before, score:defconfig is new in the list,
passes from 3.12, and the fixes are isolated, so it should be possible to backport
the necessary patches to 3.10 if desired. unicore32:defconfig passes with 3.16-rc2.
Again, it should be  straightforward to backport the necessary patches to 3.10
if so desired.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter


