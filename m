Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaAIDgC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 22:36:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaAIDf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 22:35:59 -0500
Date: Wed, 8 Jan 2014 19:36:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL 0/4] PHY: for 3.14
Message-ID: <20140109033617.GA351@kroah.com>
References: <1388076440-7620-1-git-send-email-kishon@ti.com>
 <52CCE0FD.80305@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CCE0FD.80305@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 10:54:13AM +0530, Kishon Vijay Abraham I wrote:
> Hi Greg,
> 
> On Thursday 26 December 2013 10:17 PM, Kishon Vijay Abraham I wrote:
> > Hi Greg,
> > 
> > here's the patches for 3.14. It contains few fixes on phy-core and added a new
> > PHY driver used by SATA in Marvell SoCs.
> > 
> > Let me know if you need any changes.
> > 
> > Thanks
> > Kishon
> > 
> > The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:
> > 
> >   Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for_3.14
> > 
> > for you to fetch changes up to e3eae85773ebd2165d19ca8661cca3b9c60b2ba1:
> > 
> >   Phy: Add a PHY driver for Marvell MVEBU SATA PHY. (2013-12-24 23:52:58 +0530)
> > 
> > ----------------------------------------------------------------
> > Pull request for PHY subsystem contains few fixes in PHY-CORE mostly
> > w.r.t PM and reference counting and also a new PHY driver used by SATA
> > in Marvell SoC.
> > 
> > ----------------------------------------------------------------
> > Andrew Lunn (1):
> >       Phy: Add a PHY driver for Marvell MVEBU SATA PHY.
> > 
> > Felipe Balbi (1):
> >       phy: core: properly handle failure of pm_runtime_get functions
> > 
> > Kishon Vijay Abraham I (2):
> >       phy: phy-core: increment refcounting variables only on 'success'
> >       phy: phy-core.c: remove unnecessary initialization of local variables\
> 
> 
> Will you be taking these patches?

Yes, sorry, catching up from my vacation backlog...

greg k-h
