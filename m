Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3H0W2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 18:28:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3H0W2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 18:28:36 -0400
Date: Tue, 27 Aug 2013 15:30:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 0/9] 3.0.94-stable review
Message-ID: <20130827223055.GE27592@kroah.com>
References: <20130827010251.636183797@linuxfoundation.org>
 <521C286C.9010207@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521C286C.9010207@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 09:17:48PM -0700, Guenter Roeck wrote:
> On 08/26/2013 06:04 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.0.94 release.
> > There are 9 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu Aug 29 01:02:44 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.94-rc1.gz
> > and the diffstat can be found below.
> >
> 
> Cross build results:
> 	total: 70 pass: 61 fail: 9
> Compared to 3.0.92:
> 	total: 65 pass: 57 fail: 8

Nice that our failing percentage is getting smaller :)

thanks for testing and letting me know.

greg k-h
