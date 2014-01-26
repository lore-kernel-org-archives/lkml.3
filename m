Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaAZQHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 11:07:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaAZQHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 11:07:37 -0500
Date: Sun, 26 Jan 2014 08:08:39 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/12] 3.4.78-stable review
Message-ID: <20140126160839.GA4655@kroah.com>
References: <20140126030451.934281002@linuxfoundation.org>
 <52E49A71.4020303@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E49A71.4020303@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 09:17:37PM -0800, Guenter Roeck wrote:
> On 01/25/2014 07:05 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.78 release.
> > There are 12 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue Jan 28 03:04:41 UTC 2014.
> > Anything received after that time might be too late.
> >
> 
> Build results are as expected, with the usual failures:
> 	total: 119 pass: 97 skipped: 18 fail: 4
> 
> qemu tests all passed.
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Great, thanks for testing and letting me know.

greg k-h
