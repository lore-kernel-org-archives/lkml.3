Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbbAULmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:42:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:34981 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbbAULmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:42:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,441,1418112000"; 
   d="scan'208";a="665171960"
Date: Wed, 21 Jan 2015 13:39:58 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] phy: ulpi: add driver for TI TUSB1210
Message-ID: <20150121113958.GC22716@kuha.fi.intel.com>
References: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1421745502-169447-4-git-send-email-heikki.krogerus@linux.intel.com>
 <20150120154539.GB8988@saruman>
 <20150121091749.GB22716@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121091749.GB22716@kuha.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 21, 2015 at 11:17:49AM +0200, Heikki Krogerus wrote:
> On Tue, Jan 20, 2015 at 09:45:39AM -0600, Felipe Balbi wrote:
> > > diff --git a/drivers/phy/ulpi/tusb1210.c b/drivers/phy/ulpi/tusb1210.c
> > > new file mode 100644
> > > index 0000000..ac77f98
> > > --- /dev/null
> > > +++ b/drivers/phy/ulpi/tusb1210.c
> > 
> > do you really need this extra ulpi directory ?
> > 
> > I wonder if phy-tusb1210.c as a name would be enough.
> 
> IMO grouping the ULPI PHY drivers and other ULPI bus code into
> separate folder from the start is the right thing to do.

A correction to this comment. I probable don't need this folder. Like
you said, phy-tusb1210.c should be enough..

<snip>

> > In fact, we might decide to add an entire ULPI bus, eventually, though
> > I'm still considering if there's any benefit to that.
> 
> I don't think I understand this comment? ULPI bus is what I'm
> introducing in this set (the first patch in it)?

..I talked with Alex about this :). So I think the bus belongs under
drivers/usb/core/ instead of driver/phy/. It's not really tied to the
Generic PHY framework in any way, but ULPI is of course USB specific.


Cheers,

-- 
heikki
