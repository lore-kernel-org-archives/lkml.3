Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3JCNcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:32:31 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51944 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3JCNc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:32:29 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <524D71E9.20307@roeck-us.net>
Date: Thu, 03 Oct 2013 06:32:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/52] 3.10.15-stable review
References: <20131003040522.190209641@linuxfoundation.org>
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 09:05 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.15 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Oct  5 04:05:08 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.15-rc1.gz
> and the diffstat can be found below.
>

Build results:
	total: 110 pass: 110 skipped: 0 fail: 0

qemu tests:
	All passed, with the usual warning for sh.

Details are available at at http://server.roeck-us.net:8010/builders.

Thanks,
Guenter

