Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaIDOBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:01:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbaIDOBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:01:47 -0400
Date: Thu, 4 Sep 2014 07:01:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linuxfoundation.org,
        akpm@linuxfoundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 00/88] 3.14.18-stable review
Message-ID: <20140904140146.GE12499@kroah.com>
References: <20140903220515.958924632@linuxfoundation.org>
 <20140903234429.GB27174@kroah.com>
 <5407F0C4.4080707@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5407F0C4.4080707@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 09:55:32PM -0700, Guenter Roeck wrote:
> On 09/03/2014 04:44 PM, Greg Kroah-Hartman wrote:
> >On Wed, Sep 03, 2014 at 03:04:34PM -0700, Greg Kroah-Hartman wrote:
> >>This is the start of the stable review cycle for the 3.14.18 release.
> >>There are 88 patches in this series, all will be posted as a response
> >>to this one.  If anyone has any issues with these being applied, please
> >>let me know.
> >>
> >>Responses should be made by Fri Sep  5 22:04:52 UTC 2014.
> >>Anything received after that time might be too late.
> >>
> >>The whole patch series can be found in one patch at:
> >>	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.18-rc1.gz
> >>and the diffstat can be found below.
> >
> >-rc2 is out to fix some issues:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.18-rc2.gz
> >
> 
> Build results:
> 	total: 137 pass: 137 fail: 0
> 
> Qemu tests all passed.
> 
> Detailed build and test results are available at
> http://server.roeck-us.net:8010/builders.
> 
> On a side note, I got an error on e-mails to linux-foundation.org.

There is dns issues for that domain at the moment, hopefully they will
be fixed up soon.

thanks,

greg k-h
