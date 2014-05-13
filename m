Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbaEMMe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:34:28 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62952 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760146AbaEMMe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:34:26 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53721149.1020902@roeck-us.net>
Date: Tue, 13 May 2014 05:34:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
CC: satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/182] 3.12.20-stable review
References: <cover.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 02:26 AM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.20 release.
> There are 182 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu May 15 09:25:52 2014
> Anything received after that time might be too late.
>

Build results:
	total: 127 pass: 121 skipped: 5 fail: 1

Qemu tests all passed.

Results are as expected. The failing build is unicore32:defconfig;
this is not a concern, it currently fails for all releases.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter


