Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaE1VmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:42:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42155 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaE1VmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:42:15 -0400
Message-ID: <53865820.7010309@zytor.com>
Date: Wed, 28 May 2014 14:41:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, josh@joshtriplett.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
References: <20140509191914.GA7286@jtriplet-mobl1> <53729873.2030805@zytor.com> <20140515215646.GA16326@cloud> <63645237.lSKEVJUKkQ@wuerfel>
In-Reply-To: <63645237.lSKEVJUKkQ@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 05:36 AM, Arnd Bergmann wrote:
> 
> My feeling is that all devices we can think of fall into at least one
> of these categories:
> 
> * legacy PC stuff that needs only byte access
> * PCI devices that can be accessed through sysfs
> * devices on x86 that can be accessed using iopl
> 

I don't believe PCI I/O space devices can be accessed through sysfs, but
perhaps I'm wrong?  (mmapping I/O space is not portable.)


	-hpa


