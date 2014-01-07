Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaAGPWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:22:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaAGPWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:22:16 -0500
Date: Tue, 7 Jan 2014 07:22:33 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 000/129] 3.10.26-stable review
Message-ID: <20140107152233.GA2352@kroah.com>
References: <20140106223859.589799655@linuxfoundation.org>
 <52CB8A74.7080107@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CB8A74.7080107@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 09:02:44PM -0800, Guenter Roeck wrote:
> On 01/06/2014 02:37 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.26 release.
> > There are 129 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed Jan  8 22:38:42 UTC 2014.
> > Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 111 pass: 109 skipped: 1 fail: 1
> 
> Build avr32:atngw100mkii_evklcd101_defconfig still fails.
> 
> qemu tests all passed.
> 
> Results are as expected.
> Details are available as usual at http://server.roeck-us.net:8010/builders.

Thanks for testing.

greg k-h
