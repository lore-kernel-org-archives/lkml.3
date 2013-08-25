Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3HYGvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 02:51:17 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:47886 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab3HYGvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 02:51:15 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AphGAK+oGVJV5qu1PGdsb2JhbABZgweDRCIBhQC4MYEZFwMBAQEBODWCJAEBBTocIxAIAxgJJQ8FDRgKGhOHbwMTrFoNiWoWjWmCeQeDHH0DlgWBaIY+hXiITDo
X-IronPort-AV: E=Sophos;i="4.89,950,1367964000"; 
   d="scan'208";a="606995655"
Date: Sun, 25 Aug 2013 08:56:39 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ian Munsie <darkstarsword@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: apple: Add another device ID for the mid-2013
 Macbook Air
Message-ID: <20130825065639.GA12562@polaris.bitmath.org>
References: <1377353873-17000-1-git-send-email-darkstarsword@gmail.com>
 <1377353873-17000-2-git-send-email-darkstarsword@gmail.com>
 <20130824232630.GA4454@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130824232630.GA4454@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 04:26:30PM -0700, Dmitry Torokhov wrote:
> Hi Ian,
> 
> On Sun, Aug 25, 2013 at 12:17:52AM +1000, Ian Munsie wrote:
> > This patch adds a device ID found for mid-2013 Macbook Air 6,1 from
> > lsusb:
> > 
> > Bus 001 Device 003: ID 05ac:0290 Apple, Inc.
> > 
> > Since IDs already exist for this generation Macbook air as WELLSPRING8,
> > name this one WELLSPRING8A. This only adds an ANSI version since it's
> > device ID is only one less than the existing WELLSPRING8 IDs.
> > 
> > Signed-off-by: Ian Munsie <darkstarsword@gmail.com>
> 
> Thank you for the patch!
> 
> Jiri, can I take it through my tree for 3.11?

Wait, we probably want to resolve the USB ID inconsistency first. :-)

Thanks,
Henrik
