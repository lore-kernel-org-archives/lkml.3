Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbaCUF31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 01:29:27 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55353 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbaCUF3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 01:29:25 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <532BCDE4.2060700@roeck-us.net>
Date: Thu, 20 Mar 2014 22:28:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/85] 3.10.34-stable review
References: <20140321000558.606667505@linuxfoundation.org>
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 05:09 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.34 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Mar 23 00:05:33 UTC 2014.
> Anything received after that time might be too late.
>
Build results:
	total: 126 pass: 121 skipped: 4 fail: 1

qemu tests all passed.

Results are as expected. Details are available at http://server.roeck-us.net:8010/builders.

Guenter

