Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaFMQHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:07:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaFMQHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:07:50 -0400
Date: Fri, 13 Jun 2014 09:07:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/12] 3.15.1-stable review
Message-ID: <20140613160749.GA18210@kroah.com>
References: <20140612232044.886466924@linuxfoundation.org>
 <539B15B2.9080205@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539B15B2.9080205@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 08:16:02AM -0700, Guenter Roeck wrote:
> On 06/12/2014 04:21 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.15.1 release.
> > There are 12 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat Jun 14 23:20:28 UTC 2014.
> > Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 143 pass: 135 skipped: 5 fail: 3
> Failed builds:
> 	powerpc:allmodconfig (binutils 2.23)
> 	powerpc:allmodconfig (binutils 2.24)
> 	unicore32:defconfig

Are these powerpc build failures to be expected?  I'm guessing that
unicore32 just never has built properly, right?

thanks,

greg k-h
