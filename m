Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbaLBSBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:01:07 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:45513 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545AbaLBSBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:01:05 -0500
Date: Tue, 2 Dec 2014 10:01:01 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Huang Shijie <shijie.huang@intel.com>, Huang Shijie <shijie8@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Roy Lee <roylee@paypal.com>, Mike Voytovich <mvoytovich@paypal.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/3] mtd: nand: gpmi: add proper raw access support
Message-ID: <20141202180101.GK21347@ld-irv-0074>
References: <1417371030-24015-1-git-send-email-boris.brezillon@free-electrons.com>
 <20141201084709.GI29070@brian-ubuntu>
 <20141201095858.75ac3889@bbrezillon>
 <20141202004743.GB11370@shldeISGChi005.sh.intel.com>
 <20141202092150.738a53bb@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202092150.738a53bb@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 09:21:50AM +0100, Boris Brezillon wrote:
> On Tue, 2 Dec 2014 08:47:43 +0800 Huang Shijie <shijie.huang@intel.com> wrote:
> > On Mon, Dec 01, 2014 at 09:58:58AM +0100, Boris Brezillon wrote:
> > > On Mon, 1 Dec 2014 00:47:09 -0800 Brian Norris <computersforpeace@gmail.com> wrote:
> > > > Also, is it time to yank / fixup some of these comments from
> > > > gpmi-nand.c?
> > > 
> > > I was asking myself the same question...
> > > 
> > > > 
> > > >  ...
> > > >  * FIXME: The following paragraph is incorrect, now that there exist
> > > >  * ecc.read_oob_raw and ecc.write_oob_raw functions.
> > > >  *
> > > >  * Since MTD assumes the OOB is not covered by ECC, there is no pair of
> > > >  * ECC-based/raw functions for reading or or writing the OOB. The fact that the
> > > >  * caller wants an ECC-based or raw view of the page is not propagated down to
> > > >  * this driver.
> > > >  */
> > > 
> > > I guess we can remove them.
> > > Huang can you confirm that the raw access functions introduced in this
> > > series are covering what's described here ?
> > I think we can remove these comments now.
> 
> Brian, do you want me to send this patch or are you taking care of it ?

Go ahead and send a patch.

Brian
