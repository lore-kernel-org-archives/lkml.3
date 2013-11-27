Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3K0M5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:57:19 -0500
Received: from mail.active-venture.com ([67.228.131.205]:65335 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3K0M5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:57:15 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5295EC29.3040808@roeck-us.net>
Date: Wed, 27 Nov 2013 04:57:13 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/80] 3.10.21-stable review
References: <20131127005640.934155527@linuxfoundation.org>
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 04:56 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.21 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Nov 29 00:56:25 UTC 2013.
> Anything received after that time might be too late.
>

Build results:
	total: 110 pass: 110 skipped: 0 fail: 0

qemu tests all passed.

Results are perfect.

Guenter

