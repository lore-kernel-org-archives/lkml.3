Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab3LFPJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:09:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3LFPJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:09:05 -0500
Date: Fri, 6 Dec 2013 07:10:30 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>, pavel@ucw.cz,
        pali.rohar@gmail.com
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Remove UUID helper
Message-ID: <20131206151030.GA22559@kroah.com>
References: <1385917660-2676-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <52A16932.8020909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A16932.8020909@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 08:05:38AM +0200, Ivajlo Dimitrov wrote:
> Hi Greg,
> 
> On 01.12.2013 19:07, Ivaylo DImitrov wrote:
> > From: Ivaylo Dimitrov <freemangordon@abv.bg>
> >
> > Custom uuid helper function is needed only in rmgr/dbdcd.c and doesn't
> > need to be exported. It can also be made way simpler by using sscanf.
> >
> > Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
> > ---
> >   drivers/staging/tidspbridge/Makefile               |    2 +-
> >   drivers/staging/tidspbridge/gen/uuidutil.c         |   85 --------------------
> >   .../tidspbridge/include/dspbridge/uuidutil.h       |   18 ----
> >   drivers/staging/tidspbridge/rmgr/dbdcd.c           |   42 +++++++++-
> >   4 files changed, 39 insertions(+), 108 deletions(-)
> >   delete mode 100644 drivers/staging/tidspbridge/gen/uuidutil.c
> >
> 
> I guess the initial mail somehow didn't make it through your spam filter:
> https://lkml.org/lkml/2013/12/1/70

It did, but I thought that people asked for it to be changed in the
thread afterwards, so I was expecting an updated version from you.

Care to fix things up and resend it?

thanks,

greg k-h
