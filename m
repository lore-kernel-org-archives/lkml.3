Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaKGQQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:16:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaKGQQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:16:33 -0500
Date: Fri, 7 Nov 2014 08:16:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: stable@vger.kernel.org, lwn@lwn.net, kernel-team@lists.ubuntu.com,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [ANNOUNCE] Linux 3.16.y.z extended stable support
Message-ID: <20141107161632.GB12566@kroah.com>
References: <20141030181701.GD9032@hercules>
 <20141107104328.GC8365@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107104328.GC8365@hercules>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 10:43:28AM +0000, Luis Henriques wrote:
> On Thu, Oct 30, 2014 at 06:17:01PM +0000, Luis Henriques wrote:
> > The Ubuntu kernel team is pleased to announce that we will be
> > providing extended stable support for the Linux 3.16 kernel until
> > April 2016 as a third party effort maintained on our infrastructure.
> > The team will pick up stable maintenance where Greg KH left off with
> > v3.16.7 [1].  Thank you, Greg.
> > 
> > In addition to the Ubuntu 14.10 "Utopic Unicorn" release, the Debian 8
> > "Jessie" release will also be based on this kernel [2].  Since the
> > regular support for "Jessie" will go beyond April 2016, after this
> > date Ben Hutchings (or myself) will continue the Linux 3.16 kernel
> > maintenance.
> > 
> > Our linux-3.16.y{-queue,-review} stable branches will fork from
> > v3.16.7
> > and will be published here:
> > 
> >     git://kernel.ubuntu.com/ubuntu/linux.git
> > 
> > We will use the same stable request/review workflow and follow the
> > standard upstream stable kernel rules.  More details are available
> > here [3].
> > 
> 
> In addition, I would like to announce a change in the kernel numbering
> scheme that we will be using: we are adding the string '-ckt'
> ('Canonical Kernel Team') to the kernel version.  So, for example,
> kernel '3.16.7.1' becomes '3.16.7-ckt1'.

Thank you for doing this.

greg k-h
