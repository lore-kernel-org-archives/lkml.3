Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaFXXZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:25:25 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58783 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaFXXZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:25:20 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53AA08D2.8050707@roeck-us.net>
Date: Tue, 24 Jun 2014 16:25:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/26] 3.4.95-stable review
References: <20140624154619.499002156@linuxfoundation.org>
In-Reply-To: <20140624154619.499002156@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 08:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.95 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jun 26 15:46:05 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 137 pass: 111 skipped: 20 fail: 6
Failed builds:
	alpha:allmodconfig
	arm:spear6xx_defconfig
	score:defconfig
	sparc64:allmodconfig
	unicore32:defconfig
	xtensa:allmodconfig

Qemu tests all passed.

Results are as expected. score:defconfig is new in the list. It passes from 3.12,
and the fixes are isolated, so it should be possible to backport the necessary patches
to 3.4 if desired. unicore32:defconfig passes with 3.16-rc2. Again, it should be
straightforward to backport the necessary patches to 3.4 if so desired.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

