Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaDVBOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:14:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaDVBOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:14:16 -0400
Date: Mon, 21 Apr 2014 18:14:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 00/32] 3.13.11-stable review
Message-ID: <20140422011402.GB12117@kroah.com>
References: <20140421021133.865086647@linuxfoundation.org>
 <5355C07E.7040805@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5355C07E.7040805@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 06:06:06PM -0700, Guenter Roeck wrote:
> On 04/20/2014 07:13 PM, Greg Kroah-Hartman wrote:
> > ----------------
> >
> > Note, this is the LAST 3.13.y kernel I will be releasing.  It will be
> > end-of-life after this release, please move to 3.14.y at this time.
> >
> > ----------------
> >
> > This is the start of the stable review cycle for the 3.13.11 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> 
> Build results:
> 	total: 126 pass: 122 skipped: 4 fail: 0
> 
> Qemu tests all passed. Looks good ...
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks for testing.

greg k-h
