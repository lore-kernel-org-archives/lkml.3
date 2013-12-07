Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3LGGpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 01:45:10 -0500
Received: from mail.active-venture.com ([67.228.131.205]:51567 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3LGGpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 01:45:05 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52A2C3EC.8090009@roeck-us.net>
Date: Fri, 06 Dec 2013 22:45:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/32] 3.4.73-stable review
References: <20131206214956.830407026@linuxfoundation.org>
In-Reply-To: <20131206214956.830407026@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 01:52 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.73 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Dec  8 21:49:13 UTC 2013.
> Anything received after that time might be too late.
>

Build results:
	total: 103 pass: 89 skipped: 10 fail: 4

qemu tests all passed.

Results are as expected.
Details are available as usual at http://server.roeck-us.net:8010/builders.

Guenter

