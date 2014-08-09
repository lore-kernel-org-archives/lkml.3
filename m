Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaHIDuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 23:50:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaHIDuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 23:50:22 -0400
Date: Fri, 8 Aug 2014 20:49:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.16 00/17] 3.16.1-stable review
Message-ID: <20140809034950.GB2348@kroah.com>
References: <20140808213457.511493898@linuxfoundation.org>
 <53E57279.1030106@roeck-us.net>
 <20140809034911.GA2348@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140809034911.GA2348@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 08:49:11PM -0700, Greg Kroah-Hartman wrote:
> On Fri, Aug 08, 2014 at 05:59:37PM -0700, Guenter Roeck wrote:
> > On 08/08/2014 02:35 PM, Greg Kroah-Hartman wrote:
> > >This is the start of the stable review cycle for the 3.16.1 release.
> > >There are 17 patches in this series, all will be posted as a response
> > >to this one.  If anyone has any issues with these being applied, please
> > >let me know.
> > >
> > >Responses should be made by Sun Aug 10 21:34:49 UTC 2014.
> > >Anything received after that time might be too late.
> > >
> > 
> > Build results:
> > 	total: 136 pass: 136 fail: 0
> 
> That's more than 3.15, nice!

Oops, no, one less.  What got dropped from 3.16 that was working in 3.14
and 3.15?

greg k-h
