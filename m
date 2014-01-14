Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaANC75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 21:59:57 -0500
Received: from mail.active-venture.com ([67.228.131.205]:56273 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaANC7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 21:59:53 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52D4A829.4060101@roeck-us.net>
Date: Mon, 13 Jan 2014 18:59:53 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/27] 3.4.77-stable review
References: <20140114002623.356220317@linuxfoundation.org>
In-Reply-To: <20140114002623.356220317@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 04:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.77 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jan 16 00:26:11 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 119 pass: 97 skipped: 18 fail: 4

qemu tests all passed.

Results are as expected. Note that I dropped arm:allmodconfig and replaced it with several individual builds.

Details are available as always at http://server.roeck-us.net:8010/builders.

Guenter

