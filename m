Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaFER6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:58:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaFER6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:58:09 -0400
Date: Thu, 5 Jun 2014 11:01:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 000/214] 3.4.92-stable review
Message-ID: <20140605180151.GB4121@kroah.com>
References: <20140605041639.638675216@linuxfoundation.org>
 <20140605171202.GA725@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605171202.GA725@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 10:12:02AM -0700, Guenter Roeck wrote:
> On Wed, Jun 04, 2014 at 09:16:03PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.92 release.
> > There are 214 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat Jun  7 04:15:47 UTC 2014.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 136 pass: 109 skipped: 20 fail: 7
> 
> Qemu tests all passed.
> 
> Results are as expected.
> Details are available at server.roeck-us.net:8010/builders.
> 
> I see there is an update coming to fix one of the patches; I also see
> that there is a second patch with potential problems, so maybe there will
> be another update. I'll monitor and report if there are differences in
> test results.

Thanks, that would be appreciated.

greg k-h
