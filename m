Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaGERm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 13:42:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbaGERm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 13:42:27 -0400
Date: Sat, 5 Jul 2014 10:46:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/19] 3.4.97-stable review
Message-ID: <20140705174646.GA17206@kroah.com>
References: <20140704221436.423715636@linuxfoundation.org>
 <53B78F75.6080206@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B78F75.6080206@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 10:39:01PM -0700, Guenter Roeck wrote:
> On 07/04/2014 03:15 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.4.97 release.
> >There are 19 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sun Jul  6 22:14:29 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 137 pass: 111 skipped: 20 fail: 6

111 skipped?  Did you add a bunch more targets?  Why skip them?

thanks for testing,

greg k-h
