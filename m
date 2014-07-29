Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaG2JTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:19:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37293 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaG2JTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:19:08 -0400
Date: Tue, 29 Jul 2014 12:17:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Anil Belur <askb23@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, silvio.fricke@gmail.com,
        linux-kernel@vger.kernel.org, bjorn@mork.no
Subject: Re: [PATCH 1/1] drivers: staging: vt6655: ioctl.c - missing __user
 annotation
Message-ID: <20140729091751.GB4856@mwanda>
References: <1406534292-22601-1-git-send-email-askb23@gmail.com>
 <20140729080538.GA16199@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729080538.GA16199@distanz.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 10:05:38AM +0200, Tobias Klauser wrote:
> On 2014-07-28 at 09:58:12 +0200, Anil Belur <askb23@gmail.com> wrote:
> > From: Anil Belur <askb23@gmail.com>
> > 
> > - private_ioctl() the internally calls copy_{to,from}_user() and does
> >   not use '__user' while refrencing user space pointers.
> > - this patch passes __user annotation as a cast, when the pointer is
> >  being refernced.
> 
> Wouldn't it be better to annotate the data member in struct tagSCmdRequest
> with __user instead of introducing all these casts?

Don't ask rhetorical questions on email lists.  Just be blunt.

These casts are not the correct fix.

regards,
dan carpenter
