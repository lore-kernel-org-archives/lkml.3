Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab3GQVzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:55:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab3GQVzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:55:39 -0400
Date: Wed, 17 Jul 2013 14:55:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Brunner <mibru@gmx.de>
Subject: Re: [PATCH 1/3] pch_uart: Use DMI interface for board detection
Message-ID: <20130717215544.GA15000@kroah.com>
References: <1373677087-7747-1-git-send-email-dvhart@linux.intel.com>
 <ce5dd365d05f8747d269aa74e0bb929935d9cdee.1373676797.git.dvhart@linux.intel.com>
 <1374092140.7622.36.camel@envy.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374092140.7622.36.camel@envy.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 01:15:40PM -0700, Darren Hart wrote:
> On Fri, 2013-07-12 at 17:58 -0700, Darren Hart wrote:
> > Use the DMI interface rather than manually matching DMI strings.
> 
> Greg,
> 
> The rest of this series is either being dropped or has moved on to
> netdev. This patch however remains unchanged. Would you like me to
> resend individually or can you pull in this one?

No need, it's still in my "todo" queue.  I'm trying to get the 3.11
patches merged first, before the 3.12 stuff hits my trees.  I only have
1549 more patches to get through...

greg k-h
