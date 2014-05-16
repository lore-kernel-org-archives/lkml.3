Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbaEPPBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:01:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388AbaEPPBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:01:46 -0400
Date: Fri, 16 May 2014 08:01:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: DaeSeok Youn <daeseok.youn@gmail.com>, devel <devel@driverdev.osuosl.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lidza Louina <lidza.louina@gmail.com>
Subject: Re: [PATCH] staging: dgap: implement error handling in
 dgap_tty_register()
Message-ID: <20140516150145.GA24032@kroah.com>
References: <20140425092607.GH26890@mwanda>
 <875455568.760649.1398423734122.JavaMail.root@mx2.compro.net>
 <535A5535.6000701@compro.net>
 <1016949935.761818.1398430870736.JavaMail.root@mx2.compro.net>
 <535A7402.1060305@compro.net>
 <CAHb8M2AgDzTzABys5Ec=tjg4xDaAORjPpVcjXykgWFKPtPnCMQ@mail.gmail.com>
 <20140426184721.GL26890@mwanda>
 <CAHb8M2DC==5Z40iNdq=or+9E15KH3UR-w_yeTzt1PT_-dCnZ0A@mail.gmail.com>
 <CAHb8M2C0w0wC_xEODX41k8wFs-Eq0P02WpAiCO6wdK5SnLZgMQ@mail.gmail.com>
 <20140516095247.GD16255@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516095247.GD16255@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 12:52:47PM +0300, Dan Carpenter wrote:
> On Fri, May 16, 2014 at 06:40:28PM +0900, DaeSeok Youn wrote:
> > Hi,
> > 
> >  This patch haven't been updated over the past 3 weeks.
> > Will you check for me?
> 
> Greg was trying to travel around the world in one month like Jackie
> Chan.  http://www.imdb.com/title/tt0327437/  He is back to work since
> yesterday.

Well, I'm home for a day or so before I leave again for a week, so I'm
having to prioritize things (patches or laundry) and dealing with a pet
vet emergency, so my ability to get to cleanup patches is way down the
list...

greg k-h
