Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbbAYWFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 17:05:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbAYWFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 17:05:49 -0500
Date: Sun, 25 Jan 2015 14:05:44 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.18 000/183] 3.18.4-stable review
Message-ID: <20150125220544.GB29924@kroah.com>
References: <20150125180810.160428929@linuxfoundation.org>
 <54C562CC.1090409@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C562CC.1090409@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 01:40:28PM -0800, Guenter Roeck wrote:
> On 01/25/2015 10:05 AM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.18.4 release.
> >There are 183 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Tue Jan 27 18:07:34 UTC 2015.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 133 pass: 133 fail: 0
> Qemu tests:
> 	total: 30 pass: 30 fail: 0
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks for testing all of these and letting me know, 3.10 should now be
fixed up as well.

greg k-h
