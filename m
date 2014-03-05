Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaCECLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:11:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbaCECLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:11:36 -0500
Date: Tue, 4 Mar 2014 18:11:57 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 000/172] 3.13.6-stable review
Message-ID: <20140305021157.GA18412@kroah.com>
References: <20140304200259.626667112@linuxfoundation.org>
 <53167B15.3020105@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53167B15.3020105@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 05:17:09PM -0800, Guenter Roeck wrote:
> On 03/04/2014 12:01 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.13.6 release.
> > There are 172 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu Mar  6 20:02:29 UTC 2014.
> > Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 126 pass: 122 skipped: 4 fail: 0
> 
> qemu tests all passed.
> 
> Results are as expected. Details are available at http://server.roeck-us.net:8010/builders.

Thanks for testing both of these and letting me know.

greg k-h
