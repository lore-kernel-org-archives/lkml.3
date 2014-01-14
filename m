Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaANDC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 22:02:26 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50350 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaANDCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 22:02:23 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52D4A8BF.2080207@roeck-us.net>
Date: Mon, 13 Jan 2014 19:02:23 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/62] 3.10.27-stable review
References: <20140114002710.464561569@linuxfoundation.org>
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 04:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.27 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jan 16 00:26:56 UTC 2014.
> Anything received after that time might be too late.
>

New build failures:
	m68k:allmodconfig
	sparc64:allmodconfig

drivers/net/virtio_net.c: In function 'receive_mergeable':
drivers/net/virtio_net.c:330:29: warning: dereferencing 'void *' pointer [enabled by default]
drivers/net/virtio_net.c:330:29: error: request for member 'virtual' in something not a structure or union

Caused by "virtio_net: fix error handling for mergeable buffers".

qemu tests failed for sparc64 for the same reason.

Guenter

