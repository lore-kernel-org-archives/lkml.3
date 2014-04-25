Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaDYAV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:21:57 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52333 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaDYAVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:21:55 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5359AA9E.6040605@roeck-us.net>
Date: Thu, 24 Apr 2014 17:21:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.14 00/33] 3.14.2-stable review
References: <20140424214449.423169713@linuxfoundation.org>
In-Reply-To: <20140424214449.423169713@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 02:48 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.2 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Apr 26 21:44:12 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 126 pass: 121 skipped: 4 fail: 1

Qemu tests all passed. Results are expected.
For reference, the failing build is powerpc:allmodconfig, which is failing upstream as well.

Details are available at http://server.roeck-us.net:8010/builders.

Note that the series has 34 patches for me, not 33.

Guenter

