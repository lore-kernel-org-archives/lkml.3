Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbaCEBRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:17:32 -0500
Received: from mail.active-venture.com ([67.228.131.205]:49843 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655AbaCEBRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:17:11 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <53167B15.3020105@roeck-us.net>
Date: Tue, 04 Mar 2014 17:17:09 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.13 000/172] 3.13.6-stable review
References: <20140304200259.626667112@linuxfoundation.org>
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 12:01 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.13.6 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Mar  6 20:02:29 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 126 pass: 122 skipped: 4 fail: 0

qemu tests all passed.

Results are as expected. Details are available at http://server.roeck-us.net:8010/builders.

Guenter

