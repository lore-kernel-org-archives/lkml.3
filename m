Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935692AbaDJP6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 11:58:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934295AbaDJP63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 11:58:29 -0400
Date: Thu, 10 Apr 2014 09:01:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 000/134] 3.4.87-stable review
Message-ID: <20140410160102.GE10958@kroah.com>
References: <20140410032259.587501440@linuxfoundation.org>
 <534656E3.8060106@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534656E3.8060106@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 01:31:31AM -0700, Guenter Roeck wrote:
> On 04/09/2014 08:21 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.4.87 release.
> >There are 134 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sat Apr 12 03:22:28 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 119 pass: 97 skipped: 18 fail: 4
> 
> Qemu tests all passed.
> 
> Results are as expected.
> 
> Details are available at http://server.roeck-us.net:8010/builders.
> Test scripts are at https://github.com/groeck/linux-build-test.

Great, thanks for testing and letting me know.

greg k-h
