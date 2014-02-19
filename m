Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaBSE0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 23:26:36 -0500
Received: from mail.active-venture.com ([67.228.131.205]:54376 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaBSE0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 23:26:34 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <53043277.5080807@roeck-us.net>
Date: Tue, 18 Feb 2014 20:26:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 3.4 00/24] 3.4.81-stable review
References: <20140218224550.221535225@linuxfoundation.org>
In-Reply-To: <20140218224550.221535225@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 02:46 PM, Greg Kroah-Hartman wrote:
> Many thanks to Li Zefan for digging up a bunch of these patches, that
> work is much appreciated.
>
> This is the start of the stable review cycle for the 3.4.81 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Build results:
	total: 119 pass: 97 skipped: 18 fail: 4

qemu tests all passed.

Details are available at http://server.roeck-us.net:8010/builders.

Results are as expected.

Guenter

