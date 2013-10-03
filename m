Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3JCNfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:35:42 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54841 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab3JCNfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:35:40 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <524D72A8.6080202@roeck-us.net>
Date: Thu, 03 Oct 2013 06:35:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/57] 3.11.4-stable review
References: <20131003040636.600441214@linuxfoundation.org>
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 09:08 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.11.4 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Oct  5 04:06:23 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.4-rc1.gz
> and the diffstat can be found below.
>

Build results:
	total: 110 pass: 108 skipped: 2 fail: 0

qemu tests all passed, with the usual warning for sh.

Details are available at http://server.roeck-us.net:8010/builders.
Note that 'skipped' does not indicate a fauilure. It means that the
to-be-tested configuration does not exist in this kernel version.

Thanks,
Guenter



