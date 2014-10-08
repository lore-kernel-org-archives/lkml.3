Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaJHEtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 00:49:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaJHEtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 00:49:01 -0400
Date: Tue, 7 Oct 2014 21:48:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.16 00/26] 3.16.5-stable review
Message-ID: <20141008044803.GC26820@kroah.com>
References: <20141007231848.487609292@linuxfoundation.org>
 <5434A5B1.9010408@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5434A5B1.9010408@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 07:47:13PM -0700, Guenter Roeck wrote:
> On 10/07/2014 04:19 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.16.5 release.
> >There are 26 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Oct  9 23:18:40 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 136 pass: 136 fail: 0
> Qemu tests:
> 	total: 30 pass: 30 fail: 0
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Wonderful, thanks for testing all 3 of these and letting me know.

greg k-h
