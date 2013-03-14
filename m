Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3CNWCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:02:34 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54222 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3CNWCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:02:32 -0400
Date: Thu, 14 Mar 2013 15:02:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ccg: remove two outdated dependencies
Message-ID: <20130314220229.GA7991@kroah.com>
References: <1363256224.1335.46.camel@x61.thuisdomein>
 <20130314105953.GJ9138@mwanda>
 <1363259393.1335.55.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363259393.1335.55.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 12:09:53PM +0100, Paul Bolle wrote:
> On Thu, 2013-03-14 at 13:59 +0300, Dan Carpenter wrote:
> > Your patch is fine as is, but if you wanted to send a follow on
> > patch to break the depend mess into separate lines, that would also
> > be welcome.  :)
> 
> Well, now that you somehow managed to review this patch the urge to
> clean this line up has suddenly diminished. But maybe you're lucky and
> this will not pass Greg. 

It didn't, please clean it up "properly", I'll drop this patch for now,
thanks. :)

greg k-h
