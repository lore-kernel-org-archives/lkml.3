Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab3CZBX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 21:23:29 -0400
Received: from intranet.asianux.com ([58.214.24.6]:35263 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3CZBX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 21:23:28 -0400
X-Spam-Score: -100.8
Message-ID: <5150F871.5050306@asianux.com>
Date: Tue, 26 Mar 2013 09:22:57 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "nico@linaro.org" <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/platform_data: beautify code, 'inline'
 is better in front of 'void'
References: <514FB826.9020302@asianux.com> <20130325233213.GA29245@kroah.com>
In-Reply-To: <20130325233213.GA29245@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年03月26日 07:32, Greg KH wrote:
> On Mon, Mar 25, 2013 at 10:36:22AM +0800, Chen Gang wrote:
>>
>>   better to let 'inline' in front of 'void'
> 
> Why?  What does this fix?
> 
> 
> 

  when I am compiling with "EXTRA_FLAGS=-W", I get a warning:
    make V=1 EXTRA_CFLAGS=-W ARCH=arm randconfig
    make V=1 EXTRA_CFLAGS=-W ARCH=arm menuconfig
      choose arm-linux-gnu- for cross chain prefix.
      choose S5pv210 for processor type
    make V=1 EXTRA_CFLAGS=-W ARCH=arm

  the warning is:
    include/linux/platform_data/usb-ohci-s3c2410.h:34:1: warning: ‘inline’ is not at beginning of declaration [-Wold-style-declaration]


  it is only for beautify code, not fix a bug.



  :-)


-- 
Chen Gang

Asianux Corporation
