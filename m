Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849AbaEQPo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 11:44:58 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51393 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964828AbaEQPo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 11:44:56 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <537783ED.3070900@roeck-us.net>
Date: Sat, 17 May 2014 08:44:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 0/9] 3.4.91-stable review
References: <20140516225458.512693003@linuxfoundation.org>
In-Reply-To: <20140516225458.512693003@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 03:55 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.91 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun May 18 22:54:50 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 134 pass: 109 skipped: 18 fail: 7

Qemu tests all passed.

There are two new build failures, powerpc:ppc64e_defconfig and powerpc:chroma_defconfig.
Those are not due to source code changes, but due to added builds.
Failures are seen if the images are built with binutils 2.24, and are caused by a
changed assembler ABI. A patch to fix the problem has been submitted but is not yet
upstream.

Detailed results are available at http://server.roeck-us.net:8010/builders.
powerpc builds with binutils 2.24 are shown as 'powerpc_24' architecture.

Guenter

