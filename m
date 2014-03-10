Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaCJTdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:33:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaCJTdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:33:41 -0400
Date: Mon, 10 Mar 2014 12:34:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Masood Mehmood <ody.guru@gmail.com>
Cc: devel@driverdev.osuosl.org, lidza.louina@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: dgap: Fixed sparse error: same symbol
 redeclared with different type
Message-ID: <20140310193422.GA3001@kroah.com>
References: <1394349522-20458-1-git-send-email-ody.guru@gmail.com>
 <20140310183712.GA27534@kroah.com>
 <20140309083331.GA20515@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140309083331.GA20515@localhost.localdomain>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2014 at 12:33:32AM -0800, Masood Mehmood wrote:
> On Mon, Mar 10, 2014 at 11:37:12AM -0700, Greg KH wrote:
> > On Sat, Mar 08, 2014 at 11:18:42PM -0800, Masood Mehmood wrote:
> > >  1 file changed, 6 insertions(+), 7 deletions(-)
> > 
> > I don't see a patch 1/2 here, did you forget to send it to me?
> 
> Patch 1/2 has some unrelated changes. My bad, I forgot to remove it before
> sending. Should I send a new patch or it will work as it is?

Please resend, otherwise I'll be confused again when I go to look at
patches to apply in a day or so...

thanks,

greg k-h
