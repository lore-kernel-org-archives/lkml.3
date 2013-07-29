Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab3G2SpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:45:12 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52611 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3G2SpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:45:09 -0400
Date: Mon, 29 Jul 2013 14:43:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-07-25
Message-ID: <20130729184312.GE31172@tuxdriver.com>
References: <20130725130552.GE9913@joana>
 <20130725150156.GA21959@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725150156.GA21959@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 04:01:58PM +0100, Gustavo Padovan wrote:
> Hi John,
> 
> * Gustavo Padovan <gustavo@padovan.org> [2013-07-25 14:05:54 +0100]:
> 
> > Hi John,
> > 
> > A few fixes and devices ID additions for 3.11: 
> > 
> >  * There are 3 new ath3k device ids 
> >  * Fixed stack memory usage in ath3k.
> >  * Fixed the init process of BlueFRITZ! devices, they were failing to init
> >    due to an unsupported command we sent. 
> >  * Fixed wrong use of PTR_ERR in btusb code that was preventing intel devices
> >    to work properly 
> >  * Fixed race codition between hci_register_dev() and hci_dev_open() that
> >    could cause a NULL pointer dereference.
> 
> Marcel just raised the comment that we need to add more information to
> the BlueFRITZ! fixes so I'm steping back with it. So just ignore it for
> now.
> 
> 	Gustavo

Is a new version of this request still coming?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
