Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaG3WYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:24:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaG3WYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:24:01 -0400
Date: Wed, 30 Jul 2014 15:23:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/37] 3.15.8-stable review
Message-ID: <20140730222332.GA8720@kroah.com>
References: <20140730014827.565626091@linuxfoundation.org>
 <20140730160931.GD26561@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730160931.GD26561@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 09:09:31AM -0700, Guenter Roeck wrote:
> On Tue, Jul 29, 2014 at 06:48:36PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.15.8 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri Aug  1 01:48:13 UTC 2014.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 141 pass: 141 fail: 0
> 
> Qemu tests all passed.
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks for testing all of these and letting me know.

greg k-h
