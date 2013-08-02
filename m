Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab3HBWtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:49:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3HBWtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:49:19 -0400
Date: Sat, 3 Aug 2013 06:50:36 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v01 0/3] Power Capping Framework
Message-ID: <20130802225036.GA29458@kroah.com>
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>
 <20130802223020.GB28831@kroah.com>
 <1375482806.2034.140.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375482806.2034.140.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 03:33:26PM -0700, Joe Perches wrote:
> On Sat, 2013-08-03 at 06:30 +0800, Greg KH wrote:
> > On Fri, Aug 02, 2013 at 11:08:49AM -0700, Srinivas Pandruvada wrote:
> > > Once this framework is approved, we will submit a RAPL client driver using this
> > > framework.
> > 
> > Also, given that you work with a lot of kernel developers, I would like
> > to see their review and signed-off-by: on these patches before you
> > resend them, please.  That way I know that they agree with this
> > framework as a way for their future changes in this area.
> 
> Before is a bit hard on public mailing lists isn't it?

That's implying that Intel doesn't have internal mailing lists where
kernel patches are reviewed and proposed before being made public...

> Shouldn't the reviewed-by/acked-by/signed-off-by's be
> done after a real patch is submitted?

That's fine too, but then the needed people need to be cc:ed.

thanks,

greg k-h
