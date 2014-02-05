Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbaBEVFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:05:45 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:47139 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510AbaBEVFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:05:42 -0500
Date: Wed, 5 Feb 2014 13:05:39 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.12 000/133] 3.12.10-stable review
Message-ID: <20140205210539.GA28407@roeck-us.net>
References: <20140204210737.008598235@linuxfoundation.org>
 <52F1DCB9.7060200@roeck-us.net>
 <52F2A20C.3080509@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F2A20C.3080509@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 01:41:48PM -0700, Shuah Khan wrote:
> On 02/04/2014 11:39 PM, Guenter Roeck wrote:
> >On 02/04/2014 01:06 PM, Greg Kroah-Hartman wrote:
> >>This is the start of the stable review cycle for the 3.12.10 release.
> >>There are 133 patches in this series, all will be posted as a response
> >>to this one.  If anyone has any issues with these being applied, please
> >>let me know.
> >>
> >>Responses should be made by Thu Feb  6 21:07:17 UTC 2014.
> >>Anything received after that time might be too late.
> >>
> >
> >
> >Version tested: v3.12.9-132
> >
> >Build results:
> >     total: 126 pass: 121 skipped: 5 fail: 0
> >
> >qemu tests all passed.
> >
> >Results are as expected.
> >
> >Details are available at http://server.roeck-us.net:8010/builders.
> >
> >Guenter
> >
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
> >
> >
> 
> Patch applied cleanly. boot tests passed on all test systems. No
> dmesg regressions: emerg, crit, alert, err are clean. No regressions
> in warn.
> 
> Minor Note: git apply --index complained about extra white space at
> the end of patch file. patch -p1 worked just fine.
> 
I noticed. Usually that is a problem with the original patch,
and Greg (rightfully) doesn't modify it just to avoid such messages.

Guenter
