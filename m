Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaANDEC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 22:04:02 -0500
Received: from mail.active-venture.com ([67.228.131.205]:64493 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbaANDD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 22:03:59 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52D4A91E.3020906@roeck-us.net>
Date: Mon, 13 Jan 2014 19:03:58 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.12 00/77] 3.12.8-stable review
References: <20140114002752.497010554@linuxfoundation.org>
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 04:27 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.8 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jan 16 00:27:35 UTC 2014.
> Anything received after that time might be too late.
>

Same new build failures as with 3.10:
	m68k:allmodconfig
	sparc64:allmodconfig

drivers/net/virtio_net.c: In function 'receive_mergeable':
drivers/net/virtio_net.c:333:29: warning: dereferencing 'void *' pointer [enabled by default]
drivers/net/virtio_net.c:333:29: error: request for member 'virtual' in something not a structure or union

Caused by "virtio_net: fix error handling for mergeable buffers".

qemu tests failed for sparc64 for the same reason.

Guenter

