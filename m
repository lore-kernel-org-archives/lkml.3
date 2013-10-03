Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3JCFxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:53:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50836 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3JCFxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 01:53:44 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <524D0663.209@roeck-us.net>
Date: Wed, 02 Oct 2013 22:53:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/13] 3.0.99-stable review
References: <20131003040400.753642257@linuxfoundation.org>
In-Reply-To: <20131003040400.753642257@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 09:04 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.99 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Oct  5 04:03:47 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.99-rc1.gz
> and the diffstat can be found below.
>

Heads up: I am getting lots of build failures in 3.0 and 3.4 builds.

mm/built-in.o: In function `__put_compound_page':
slab.c:(.text+0xaa3c): undefined reference to `PageHuge'
mm/built-in.o: In function `put_compound_page':
slab.c:(.text+0xaab0): undefined reference to `PageHuge'
mm/built-in.o: In function `__get_page_tail':
slab.c:(.text+0xb178): undefined reference to `PageHuge'
make: *** [.tmp_vmlinux1] Error 1

More tomorrow.

Guenter

