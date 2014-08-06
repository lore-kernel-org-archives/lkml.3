Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaHFCjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 22:39:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaHFCjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 22:39:09 -0400
Date: Tue, 5 Aug 2014 19:38:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/42] 3.15.9-stable review
Message-ID: <20140806023837.GA9811@kroah.com>
References: <20140805181321.018370988@linuxfoundation.org>
 <53E1947E.8080101@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E1947E.8080101@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 07:35:42PM -0700, Guenter Roeck wrote:
> On 08/05/2014 11:13 AM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.15.9 release.
> >There are 42 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Aug  7 18:13:05 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 137 pass: 137 fail: 0
> 
> Qemu tests all passed.
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Great, thanks for testing all of these and letting me know.

greg k-h
