Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaDCWnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:43:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaDCWm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:42:57 -0400
Date: Thu, 3 Apr 2014 15:45:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 00/22] 3.13.9-stable review
Message-ID: <20140403224519.GA13754@kroah.com>
References: <20140401040703.045139933@linuxfoundation.org>
 <533B53D6.9030304@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533B53D6.9030304@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 05:03:34PM -0700, Guenter Roeck wrote:
> On 03/31/2014 09:08 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.13.9 release.
> >There are 22 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Apr  3 04:06:39 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
>         total: 126 pass: 122 skipped: 4 fail: 0
> 
> Qemu tests all passed. The previously observed powerpc failures are gone
> with this version.
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks for testing all of these.

greg k-h
