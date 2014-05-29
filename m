Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965261AbaE2OeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:34:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54672 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281AbaE2OeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:34:11 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53874550.7090908@roeck-us.net>
Date: Thu, 29 May 2014 07:33:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
CC: satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/103] 3.12.21-stable review
References: <cover.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 06:48 AM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.21 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Jun  2 13:47:39 2014
> Anything received after that time might be too late.
>

Build results:
	total: 143 pass: 133 skipped: 7 fail: 3

Qemu tests all passed.

For reference, failing builds are

unicore32:defconfig		- still fails for all releases
powerpc:ppc64e_defconfig	- fail if built with binutils 2.4; patch pending
powerpc:chroma_defconfig	- fail if built with binutils 2.4; patch pending

Results are as expected. Details are available at http://server.roeck-us.net:8010/builders.

Guenter

