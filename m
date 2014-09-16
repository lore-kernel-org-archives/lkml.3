Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaIPSFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:05:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbaIPSFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:05:17 -0400
Date: Tue, 16 Sep 2014 11:04:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/71] 3.10.55-stable review
Message-ID: <20140916180429.GA24080@kroah.com>
References: <20140915192638.702282534@linuxfoundation.org>
 <54179836.4090901@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54179836.4090901@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 06:53:58PM -0700, Guenter Roeck wrote:
> On 09/15/2014 12:25 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.55 release.
> >There are 71 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Wed Sep 17 19:26:27 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 137 pass: 137 fail: 0
> 
> Qemu test results:
> 	total: 21 pass: 21 fail: 0
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks for testing all of these and letting me know.

greg k-h
