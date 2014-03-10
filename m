Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaCJQuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:50:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbaCJQuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:50:19 -0400
Date: Mon, 10 Mar 2014 09:50:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com,
        devel@linuxdriverproject.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>
Subject: Re: Treewide frequency of various checkpatch messages
Message-ID: <20140310165046.GA12687@kroah.com>
References: <1394104358-23438-1-git-send-email-kys@microsoft.com>
 <1394104390-23477-1-git-send-email-kys@microsoft.com>
 <20140306.142919.763823800315842610.davem@davemloft.net>
 <1394148520.16156.8.camel@joe-AO722>
 <20140307075247.GA29018@mwanda>
 <1394184637.16156.58.camel@joe-AO722>
 <1394467346.24244.14.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394467346.24244.14.camel@joe-AO722>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 09:02:26AM -0700, Joe Perches wrote:
> On Fri, 2014-03-07 at 01:30 -0800, Joe Perches wrote:
> > On Fri, 2014-03-07 at 10:54 +0300, Dan Carpenter wrote:
>  (a question about a new message warning of a missing
>   blank line between variable declaration blocks and
>   code in a function)
> > > How many warnings does this generate does this generate when you run it
> > > across the whole tree?
> > A lot.
> 
> Turns out it's 20,210 and it's the 14th
> most common checkpatch message type.
> 
>     14    20210  WARNING:SPACING: Missing a blank line after declarations

I think it's still worthwhile to clean up.

thanks,

greg k-h
