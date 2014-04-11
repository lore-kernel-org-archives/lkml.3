Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422889AbaDKQpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:45:50 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.171]:46087 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754529AbaDKQpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:45:43 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 12:45:42 EDT
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-13.tower-38.messagelabs.com!1397234316!14206713!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Fri, 11 Apr 2014 18:38:36 +0200
Date: Fri, 11 Apr 2014 18:38:29 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: MCB fixes for 3.15-rc1
Message-ID: <20140411163829.GA10895@jtlinux>
References: <20140411064829.GA11402@jtlinux>
 <20140411141634.GE3343@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140411141634.GE3343@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 07:16:34AM -0700, Greg Kroah-Hartman wrote:
> On Fri, Apr 11, 2014 at 08:48:40AM +0200, Johannes Thumshirn wrote:
> > Hi Greg,
> >
> > Please pull this change for drivers/mcb.
> >
> > Thanks
> > 	Johannes
> >
> > --
> >
> > The following changes since commit 9e897e13bd46fa03485468609741974259a8c573:
> >
> >   Merge branch 'for-linus' of git://git.open-osd.org/linux-open-osd (2014-04-10 14:33:02 -0700)
> >
> > are available in the git repository at:
> >
> >
> >   git://github.com/morbidrsa/linux.git mcb
> >
> > for you to fetch changes up to e383c2430770c4bb080b4915826f34b729b33bbc:
> >
> >   drivers: mcb: fix memory leak in chameleon_parse_cells() error path (2014-04-11 08:37:37 +0200)
>
> I really don't like taking git pull requests, and will not take one from
> a non-kernel.org tree, nor one without a signed tag.
>
> For just a single patch like this, just send it through email.  Much
> faster and simpler.
>

OK, comming right away.

> Oh, and go get a kernel.org account :)
>


OK, I'll do my best.

> thanks,
>
> greg k-h

Nice Weekend,
     Johannes
