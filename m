Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaANDDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 22:03:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaANDDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 22:03:39 -0500
Date: Mon, 13 Jan 2014 19:03:50 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/27] 3.4.77-stable review
Message-ID: <20140114030350.GA26887@kroah.com>
References: <20140114002623.356220317@linuxfoundation.org>
 <52D4A829.4060101@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D4A829.4060101@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 06:59:53PM -0800, Guenter Roeck wrote:
> On 01/13/2014 04:26 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.77 release.
> > There are 27 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu Jan 16 00:26:11 UTC 2014.
> > Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 119 pass: 97 skipped: 18 fail: 4
> 
> qemu tests all passed.
> 
> Results are as expected. Note that I dropped arm:allmodconfig and replaced it with several individual builds.
> 
> Details are available as always at http://server.roeck-us.net:8010/builders.

Great, thanks for testing.

greg k-h
