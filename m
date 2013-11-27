Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3K0EKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 23:10:55 -0500
Received: from mail.active-venture.com ([67.228.131.205]:55765 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3K0EKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 23:10:50 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <529570C8.2080205@roeck-us.net>
Date: Tue, 26 Nov 2013 20:10:48 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.12 000/116] 3.12.2-stable review
References: <20131127005736.915454872@linuxfoundation.org>
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 04:56 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.2 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Nov 29 00:57:18 UTC 2013.
> Anything received after that time might be too late.
>

Build results:
	total: 110 pass: 107 skipped: 3 fail: 0

qemu tests all passed.

Perfect results.

Thanks,
Guenter

