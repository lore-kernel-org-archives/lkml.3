Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3K0EMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 23:12:09 -0500
Received: from mail.active-venture.com ([67.228.131.205]:62891 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3K0EMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 23:12:07 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52957116.40308@roeck-us.net>
Date: Tue, 26 Nov 2013 20:12:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.11 00/36] 3.11.10-stable review
References: <20131126181025.029404973@linuxfoundation.org>
In-Reply-To: <20131126181025.029404973@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 10:12 AM, Greg Kroah-Hartman wrote:
> ---------------------------------
> NOTE:
>    This is the LAST 3.11.x kernel I will be releasing.  Everyone should
>    be moving to the 3.12.x series at this point in time.  After this
>    kernel is released, 3.11 will be end-of-life.
> ---------------------------------
>
> This is the start of the stable review cycle for the 3.11.10 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Nov 28 18:08:16 UTC 2013.
> Anything received after that time might be too late.
>

Build results:
	total: 110 pass: 108 skipped: 2 fail: 0

qemu tests all passed.

Perfect results.

Guenter

