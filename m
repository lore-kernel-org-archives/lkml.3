Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaLOEY2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 23:24:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaLOEY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 23:24:26 -0500
Date: Sun, 14 Dec 2014 20:24:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.18 00/19] 3.18.1-stable review
Message-ID: <20141215042425.GA3692@kroah.com>
References: <20141214201823.543296369@linuxfoundation.org>
 <548E5678.8030703@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548E5678.8030703@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 07:33:12PM -0800, Guenter Roeck wrote:
> On 12/14/2014 12:21 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.18.1 release.
> >There are 19 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Tue Dec 16 20:18:16 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 133 pass: 133 fail: 0
> 
> Qemu tests:
> 	total: 30 pass: 30 fail: 0
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks for testing and letting me know about all of these.

greg k-h
