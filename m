Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaAGPWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:22:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaAGPW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:22:28 -0500
Date: Tue, 7 Jan 2014 07:22:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/43] 3.4.76-stable review
Message-ID: <20140107152240.GB2352@kroah.com>
References: <20140106223942.259651490@linuxfoundation.org>
 <52CB8A18.9060104@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CB8A18.9060104@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 09:01:12PM -0800, Guenter Roeck wrote:
> On 01/06/2014 02:39 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.76 release.
> > There are 43 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed Jan  8 22:39:27 UTC 2014.
> > Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 104 pass: 89 skipped: 11 fail: 4
> 
> qemu tests all passed.
> 
> Results are as expected.
> Details are available as usual at http://server.roeck-us.net:8010/builders.

Thanks for testing.

greg k-h
