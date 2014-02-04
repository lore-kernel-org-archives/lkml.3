Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaBDQxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:53:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50862 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbaBDQw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:52:57 -0500
Message-ID: <52F11AE5.9000502@infradead.org>
Date: Tue, 04 Feb 2014 08:52:53 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-media <linux-media@vger.kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: linux-next: Tree for Feb 4 (media/radio/si4713/radio-usb-si4713.c)
References: <20140204160704.0cf4cb0ccf45f413056e7f34@canb.auug.org.au>
In-Reply-To: <20140204160704.0cf4cb0ccf45f413056e7f34@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 09:07 PM, Stephen Rothwell wrote:
> Hi all,
> 
> This tree fails (more than usual) the powerpc allyesconfig build.
> 
> Changes since 20140203:
> 

on i386:

# CONFIG_I2C is not set

  CC [M]  drivers/media/radio/si4713/radio-usb-si4713.o
drivers/media/radio/si4713/radio-usb-si4713.c: In function 'usb_si4713_video_device_release':
drivers/media/radio/si4713/radio-usb-si4713.c:147:2: error: implicit declaration of function 'i2c_del_adapter' [-Werror=implicit-function-declaration]
drivers/media/radio/si4713/radio-usb-si4713.c: In function 'si4713_register_i2c_adapter':
drivers/media/radio/si4713/radio-usb-si4713.c:424:2: error: implicit declaration of function 'i2c_add_adapter' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[5]: *** [drivers/media/radio/si4713/radio-usb-si4713.o] Error 1



-- 
~Randy
