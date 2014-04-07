Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaDGDzJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 23:55:09 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58762 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaDGDzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 23:55:06 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53422195.9060108@roeck-us.net>
Date: Sun, 06 Apr 2014 20:55:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 00/18] 3.2.57-rc1 review
References: <lsq.1396827347.462803115@decadent.org.uk>
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2014 04:35 PM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.57 release.
> There are 18 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Apr 09 00:00:00 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 116 pass: 87 skipped: 22 fail: 7

qemu tests all passed. Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter


