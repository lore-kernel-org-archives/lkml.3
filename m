Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaBEGiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 01:38:14 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50379 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBEGiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 01:38:12 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52F1DC55.2070907@roeck-us.net>
Date: Tue, 04 Feb 2014 22:38:13 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 000/104] 3.10.29-stable review
References: <20140204210222.731641778@linuxfoundation.org>
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 01:01 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.29 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Feb  6 21:02:03 UTC 2014.
> Anything received after that time might be too late.
>

Version tested: v3.10.28-103

Build results:
     total: total: 126 pass: 121 skipped: 4 fail: 1

qemu tests all passed.

Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter



