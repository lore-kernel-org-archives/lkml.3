Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab3I0PYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:24:22 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:36561 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3I0PYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:24:19 -0400
Date: Fri, 27 Sep 2013 12:24:13 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-09-23
Message-ID: <20130927152413.GC13211@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20130923210049.GG18215@joana>
 <20130926174750.GB1931@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926174750.GB1931@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

2013-09-26 John W. Linville <linville@tuxdriver.com>:

> On Mon, Sep 23, 2013 at 06:00:49PM -0300, Gustavo Padovan wrote:
> > Hi John,
> > 
> > First Bluetooth fixes to 3.12, it includes:
> > 
> > * 3 patches to add device id for 3 new hardwares.
> > 
> > * 2 patches from Johan to fix the rfkill behaviour during setup stage
> > 
> > * a small clean up in the rfcomm TTY code that fixes a potential racy
> > condition (by Gianluca Anzolin)
> > 
> > * 2 fixes to proper set encryption key size and security level in the
> > peripheral role of Bluetooth LE devices. (by Andre Guedes)
> > 
> > * a fix for dealing devices where pairing is not necessary, we were keeping
> > the Bluetooth ACL connection alive for too much time. (by Syam Sidhardhan)
> > 
> > Please pull or let me know of any problems! Thanks!
> > 
> > 
> > 	Gustavo
> > 
> > ---
> > The following changes since commit f4e1a4d3ecbb9e42bdf8e7869ee8a4ebfa27fb20:
> > 
> >   rt2800: change initialization sequence to fix system freeze (2013-09-09 14:44:34 -0400)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master
> > 
> > for you to fetch changes up to 5bcecf325378218a8e248bb6bcae96ec7362f8ef:
> > 
> >   Bluetooth: btusb: Add support for Belkin F8065bf (2013-09-23 17:44:25 -0300)
> 
> Pulling now...

Thanks for pulling. However as Stephen pointed out in the linux-next merge
conflict email from today we have a style issue, a closing brace bad indented.
This is from conflict resolution I made last week. I fixed it when merging
bluetooth.git into bluetooth-next.git. 

So when pushing this to Dave could you please tell him about this issue and
that the fix is already provided by bluetooth-next. Do you agree with this
solution?

	Gustavo
