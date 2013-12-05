Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab3LERqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:46:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab3LERqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:46:17 -0500
Date: Thu, 5 Dec 2013 09:46:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next] mei: add 9 series PCH mei device ids
Message-ID: <20131205174615.GA7383@kroah.com>
References: <1386228884-30978-1-git-send-email-tomas.winkler@intel.com>
 <20131205143153.GA5151@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AF24D4C@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AF24D4C@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 04:50:00PM +0000, Winkler, Tomas wrote:
> 
> 
> > On Thu, Dec 05, 2013 at 09:34:44AM +0200, Tomas Winkler wrote:
> > > And Lynx Point H Refresh and Wildcat Point LP
> > > device ids.
> > >
> > > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > > ---
> > > V2: remove duplicated  LPT entry
> > >
> > >  drivers/misc/mei/hw-me-regs.h | 5 ++++-
> > >  drivers/misc/mei/pci-me.c     | 4 +++-
> > >  2 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > This should go into 3.13-final, right?  What about -stable versions?
> 
> Yes, this can go to stable as well. I need to dig bit in from which
> version this is relevant, I think 3.9 and up
> I will resend with info.
> Can you just clarify for me what is the policy here, is the support
> for new HW a stable candidate?

Please read Documentation/stable_kernel_rules.txt for the stable rules.

