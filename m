Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab3HMR7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:59:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab3HMR7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:59:11 -0400
Date: Tue, 13 Aug 2013 10:59:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/12] 3.0.91-stable review
Message-ID: <20130813175910.GD7336@kroah.com>
References: <20130813063520.285638946@linuxfoundation.org>
 <520A1C9E.4040102@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520A1C9E.4040102@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 04:46:38AM -0700, Guenter Roeck wrote:
> On 08/12/2013 11:35 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.0.91 release.
> >There are 12 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Aug 15 06:35:11 UTC 2013.
> >Anything received after that time might be too late.
> >
> Cross build results:
> 	Total builds: 58 Total build errors: 14
> 
> qemu test results (images loading to login prompt):
> 	ppc, x86, x86_64 tested ok
> 
> Details:
> 	http://server.roeck-us.net:8010/waterfall
> 
> Everything working as expected.

That's good, thanks for testing.

greg k-h
