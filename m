Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaKGKnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:43:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33742 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaKGKnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:43:31 -0500
Date: Fri, 7 Nov 2014 10:43:28 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: stable@vger.kernel.org
Cc: lwn@lwn.net, kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: Re: [ANNOUNCE] Linux 3.16.y.z extended stable support
Message-ID: <20141107104328.GC8365@hercules>
References: <20141030181701.GD9032@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141030181701.GD9032@hercules>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 06:17:01PM +0000, Luis Henriques wrote:
> The Ubuntu kernel team is pleased to announce that we will be
> providing extended stable support for the Linux 3.16 kernel until
> April 2016 as a third party effort maintained on our infrastructure.
> The team will pick up stable maintenance where Greg KH left off with
> v3.16.7 [1].  Thank you, Greg.
> 
> In addition to the Ubuntu 14.10 "Utopic Unicorn" release, the Debian 8
> "Jessie" release will also be based on this kernel [2].  Since the
> regular support for "Jessie" will go beyond April 2016, after this
> date Ben Hutchings (or myself) will continue the Linux 3.16 kernel
> maintenance.
> 
> Our linux-3.16.y{-queue,-review} stable branches will fork from
> v3.16.7
> and will be published here:
> 
>     git://kernel.ubuntu.com/ubuntu/linux.git
> 
> We will use the same stable request/review workflow and follow the
> standard upstream stable kernel rules.  More details are available
> here [3].
> 

In addition, I would like to announce a change in the kernel numbering
scheme that we will be using: we are adding the string '-ckt'
('Canonical Kernel Team') to the kernel version.  So, for example,
kernel '3.16.7.1' becomes '3.16.7-ckt1'.

Note that this change applies *only* to the 3.16 kernel, although in
the future we may consider doing it for other kernels we are currently
maintaining.

Cheers,
--
Luís

> We welcome any feedback and contribution to this effort.  We will be
> posting the first review cycle patch set in a week or two.
> 
> [1] https://lkml.org/lkml/2014/10/30/583
> [2] https://lists.debian.org/debian-kernel/2014/07/msg00413.html
> [3] http://wiki.ubuntu.com/Kernel/Dev/ExtendedStable
> 
> Cheers,
> -- 
> Luís Henriques
> Ubuntu Kernel Team, Canonical Ltd.
> 
> -- 
> kernel-team mailing list
> kernel-team@lists.ubuntu.com
> https://lists.ubuntu.com/mailman/listinfo/kernel-team
