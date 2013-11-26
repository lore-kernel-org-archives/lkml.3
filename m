Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab3KZQjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:39:25 -0500
Received: from mail.active-venture.com ([67.228.131.205]:64077 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277Ab3KZQjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:39:24 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5294CEB8.7080203@roeck-us.net>
Date: Tue, 26 Nov 2013 08:39:20 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 00/87] 3.2.53-rc1 review
References: <lsq.1385387069.559528559@decadent.org.uk>
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 05:44 AM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.53 release.
> There are 87 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Nov 27 13:44:29 UTC 2013.
> Anything received after that time might be too late.
>

Build test results:
	total: 100 pass: 78 skipped: 14 fail: 8

Qemu tests all pass.

This matches the previous results, so everything is as expected.

Thanks,
Guenter

