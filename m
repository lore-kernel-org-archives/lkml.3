Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaBLLuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:50:37 -0500
Received: from mail.active-venture.com ([67.228.131.205]:63935 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaBLLug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:50:36 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52FB600A.3060903@roeck-us.net>
Date: Wed, 12 Feb 2014 03:50:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 00/79] 3.2.55-rc1 review
References: <lsq.1392192611.998273004@decadent.org.uk>
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 12:10 AM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.55 release.
> There are 79 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Feb 14 09:00:00 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 116 pass: 87 skipped: 22 fail: 7

qemu tests all passed.

Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

