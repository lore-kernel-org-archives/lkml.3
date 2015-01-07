Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbbAGXq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:46:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbbAGXq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:46:26 -0500
Date: Wed, 7 Jan 2015 15:46:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.17 00/73] 3.17.8-stable review
Message-ID: <20150107234625.GB19926@kroah.com>
References: <20150107021557.521276020@linuxfoundation.org>
 <54AD389A.5000808@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AD389A.5000808@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 05:46:02AM -0800, Guenter Roeck wrote:
> On 01/06/2015 06:15 PM, Greg Kroah-Hartman wrote:
> >NOTE, this is the LAST 3.17-stable kernel to be released, you should
> >move to 3.18 by now, as 3.17 is end-of-life after this release.
> >
> >
> >
> >This is the start of the stable review cycle for the 3.17.8 release.
> >There are 73 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> 
> Build results:
> 	total: 133 pass: 132 fail: 1
> Failed builds:
> 	avr32:atngw100mkii_evklcd101_defconfig
> 
> Qemu tests:
> 	total: 30 pass: 30 fail: 0
> 
> Details are available at http://server.roeck-us.net:8010/builders.
> 
> It looks like you didn't apply the patch needed to address
> the avr32 build problem, so results are as expected.

Yeah, I didn't get to that one, oh well, no one seemed to really care :)

Thanks for testing all 4 of these and letting me know.

greg k-h
