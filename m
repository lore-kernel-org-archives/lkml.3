Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaBERgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:36:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaBERgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:36:09 -0500
Date: Wed, 5 Feb 2014 09:37:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 000/140] 3.13.2-stable review
Message-ID: <20140205173717.GB10652@kroah.com>
References: <20140204211036.967663852@linuxfoundation.org>
 <52F1DD0B.4070100@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F1DD0B.4070100@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 10:41:15PM -0800, Guenter Roeck wrote:
> On 02/04/2014 01:09 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.13.2 release.
> >There are 140 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Feb  6 21:10:18 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Version tested: v3.13.1-139
> 
> Build results:
>     total: 126 pass: 122 skipped: 4 fail: 0
> 
> qemu tests all passed.
> 
> Results are as expected.
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Very nice to see all 4 -rc releases passed this, thanks for letting me
know.

greg k-h
