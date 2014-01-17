Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaAQMKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:10:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:22925 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbaAQMKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:10:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="466648398"
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
To: Tejun Heo <tj@kernel.org>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] libahci: correct a misleading comment
Thread-Topic: [PATCH] libahci: correct a misleading comment
Thread-Index: AQHPE3u6qr9QrrQdM0KlDHqFcZQxo5qI0vRA
Date: Fri, 17 Jan 2014 12:10:46 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A6A3344@IRSMSX105.ger.corp.intel.com>
References: <20140117114319.2784.3961.stgit@gklab-154-244.igk.intel.com>
 <20140117120016.GB8598@htj.dyndns.org>
In-Reply-To: <20140117120016.GB8598@htj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 17, 2014 1:00 PM Tejun Heo <tj@kernel.org> wrote:
> On Fri, Jan 17, 2014 at 12:43:20PM +0100, Lukasz Dorau wrote:
> > There is an error in a comment introduced by:
> > 	commit fa070ee6dc70bcc19737a2406d741b089b3149d5
> > 	libahci: fix turning on LEDs in ahci_start_port()
> >
> > Correct it.
> >
> > Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> > ---
> >  drivers/ata/libahci.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> > index c482f8c..1f526e6 100644
> > --- a/drivers/ata/libahci.c
> > +++ b/drivers/ata/libahci.c
> > @@ -780,8 +780,8 @@ static void ahci_start_port(struct ata_port *ap)
> >  							       4);
> >  				/*
> >  				 * If busy, give a breather but do not
> > -				 * release EH ownership by using msleep()
> > -				 * instead of ata_msleep().  EM Transmit
> > +				 * release EH ownership by using ata_msleep()
> > +				 * instead of msleep().  EM Transmit
> 
> Can't the sentence be parsed to mean the same thing either way?  "(do
> not release EH ownership) by using msleep..." or "do not (release EH
> ownership by using ata_msleep)..."
> 
> With the context, I don't think which way to group things is
> ambiguous.  In fact, saying "instead of msleep()" is kinda confusing
> because using ata_msleep() should be the default.
> 

You are right. I give up ;-)

Thanks,
Lukasz

