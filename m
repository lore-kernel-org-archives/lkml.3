Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab3I0SJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:09:42 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50774 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3I0SJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:09:40 -0400
Date: Fri, 27 Sep 2013 14:04:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-09-23
Message-ID: <20130927180443.GA10994@tuxdriver.com>
References: <20130923210049.GG18215@joana>
 <20130926174750.GB1931@tuxdriver.com>
 <20130927152413.GC13211@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927152413.GC13211@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 12:24:13PM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> 2013-09-26 John W. Linville <linville@tuxdriver.com>:
> 
> > On Mon, Sep 23, 2013 at 06:00:49PM -0300, Gustavo Padovan wrote:

> > > The following changes since commit f4e1a4d3ecbb9e42bdf8e7869ee8a4ebfa27fb20:
> > > 
> > >   rt2800: change initialization sequence to fix system freeze (2013-09-09 14:44:34 -0400)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master
> > > 
> > > for you to fetch changes up to 5bcecf325378218a8e248bb6bcae96ec7362f8ef:
> > > 
> > >   Bluetooth: btusb: Add support for Belkin F8065bf (2013-09-23 17:44:25 -0300)
> > 
> > Pulling now...
> 
> Thanks for pulling. However as Stephen pointed out in the linux-next merge
> conflict email from today we have a style issue, a closing brace bad indented.
> This is from conflict resolution I made last week. I fixed it when merging
> bluetooth.git into bluetooth-next.git. 
> 
> So when pushing this to Dave could you please tell him about this issue and
> that the fix is already provided by bluetooth-next. Do you agree with this
> solution?

I fixed it in my merge for Dave -- I think that will be fine.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
