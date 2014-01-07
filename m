Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaAGSuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:50:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaAGSub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:50:31 -0500
Date: Tue, 7 Jan 2014 10:50:59 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 000/144] 3.12.7-stable review
Message-ID: <20140107185059.GC4223@kroah.com>
References: <20140106223745.326293132@linuxfoundation.org>
 <52CB8B0D.2090000@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CB8B0D.2090000@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 09:05:17PM -0800, Guenter Roeck wrote:
> On 01/06/2014 02:36 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.12.7 release.
> >There are 144 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Wed Jan  8 22:37:25 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 111 pass: 107 skipped: 4 fail: 0	
> 
> qemu tests all passed.
> 
> Results are as expected.
> Details are available as usual at http://server.roeck-us.net:8010/builders.

Thanks for testing.

greg k-h
