Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaCJTke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:40:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaCJTkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:40:33 -0400
Date: Mon, 10 Mar 2014 12:41:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Stefani Seibold <stefani@seibold.net>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [x86, vdso]  BUG: unable to handle kernel paging request at
 d34bd000
Message-ID: <20140310194108.GD3392@kroah.com>
References: <20140307013833.GD8427@localhost>
 <1394182034.21684.6.camel@wall-e.seibold.net>
 <20140307091515.GA8888@localhost>
 <1394186248.28066.42.camel@wall-e.seibold.net>
 <20140307234411.GA14886@localhost>
 <1394352497.1002.4.camel@wall-e.seibold.net>
 <531D009F.1060803@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531D009F.1060803@linux.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2014 at 05:00:31PM -0700, H. Peter Anvin wrote:
> On 03/09/2014 12:08 AM, Stefani Seibold wrote:
> > 
> > This was not addressed to you, it was addressed to the x86 intel kernel
> > developers to do more testing, since this piece of code has so many side
> > effects. I apologizes this miss understanding.
> > 
> 
> I think you're misunderstanding.
> 
> We cannot debug every single contributors' code for them.  There isn't
> enough of us to go around.  We have in fact stretched well beyond the
> point which we usually can accommodate for this particular patchset.

What is failing in the tests that need to be fixed up?

I can look into this next week when I return.

thanks,

greg k-h
