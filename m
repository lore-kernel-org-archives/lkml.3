Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab3HPI0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:26:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64177 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab3HPI0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:26:08 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520DE21D.8000905@roeck-us.net>
Date: Fri, 16 Aug 2013 01:26:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Subject: Re: [ 00/17] 3.4.58-stable review
References: <20130813063501.728847844@linuxfoundation.org> <520A1D56.2050507@roeck-us.net> <20130813175858.GC7336@kroah.com> <20130813201936.GA18358@roeck-us.net> <20130815063158.GB25754@kroah.com> <520C86BD.2020903@roeck-us.net> <CAMuHMdU+EOC_etihOzUC6N0cqc2qHaGm3_L+gyTRxESCGhOzEg@mail.gmail.com> <520DB045.7000309@roeck-us.net> <20130816051041.GA23784@kroah.com>
In-Reply-To: <20130816051041.GA23784@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 10:10 PM, Greg Kroah-Hartman wrote:
[ .. ]

>> three to go (arm:allmodconfig, sparc32:defconfig, and sparc64:allmodconfig).
>

Please add (in this order) the following patches to 3.4.

de36e66d5f sparc32: add ucmpdi2
74c7b28953 sparc32: Add ucmpdi2.o to obj-y instead of lib-y.

This fixes the sparc32:defconfig build error.

Thanks,
Guenter

