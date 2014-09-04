Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaIDOC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:02:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaIDOC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:02:26 -0400
Date: Thu, 4 Sep 2014 07:02:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/55] 3.10.54-stable review
Message-ID: <20140904140225.GF12499@kroah.com>
References: <20140903220453.653576908@linuxfoundation.org>
 <20140903234405.GA27174@kroah.com>
 <5407EF92.1060508@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5407EF92.1060508@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 09:50:26PM -0700, Guenter Roeck wrote:
> On 09/03/2014 04:44 PM, Greg Kroah-Hartman wrote:
> >On Wed, Sep 03, 2014 at 03:04:50PM -0700, Greg Kroah-Hartman wrote:
> >>This is the start of the stable review cycle for the 3.10.54 release.
> >>There are 55 patches in this series, all will be posted as a response
> >>to this one.  If anyone has any issues with these being applied, please
> >>let me know.
> >>
> >>Responses should be made by Fri Sep  5 22:04:21 UTC 2014.
> >>Anything received after that time might be too late.
> >>
> >>The whole patch series can be found in one patch at:
> >>	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.54-rc1.gz
> >>and the diffstat can be found below.
> >
> >-rc2 is now out to resolve some reported errors:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.54-rc2.gz
> >
> >
> Build results:
> 	total: 137 pass: 137 fail: 0
> 
> Most of the qemu tests passed except for mips:smp, which crashes with
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: kjournald/44
> 
> This is not a new problem, but an old one discovered due to an added
> qemu test. I sent you a reference to a patch to fix this problem
> a couple of weeks ago. Let me know if I should resend it.

My stable patch queue is well over 200 patches yet to be applied, don't
worry, it's not lost, just behind a bunch of others...

thanks for testing all of these.

greg k-h
