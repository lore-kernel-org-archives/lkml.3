Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584Ab3BYOOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:14:53 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:53206 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab3BYOOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:14:52 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQ7AFVxK1FV5qjOPGdsb2JhbABFhWYjhH22ToEFFwMBAQEBODSCHwEBBTocIxAIAw4KCQwZDwUlChqIKr4uFY55BwqCVWEDljyGBY1p
X-IronPort-AV: E=Sophos;i="4.84,736,1355094000"; 
   d="scan'208";a="503180783"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 25 Feb 2013 15:16:51 +0100
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] hid driver transport cleanup
Message-ID: <20130225141651.GA506@polaris.bitmath.org>
References: <1361788310-6048-1-git-send-email-benjamin.tissoires@gmail.com>
 <alpine.LNX.2.00.1302251328070.2128@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1302251328070.2128@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 01:29:40PM +0100, Jiri Kosina wrote:
> On Mon, 25 Feb 2013, Benjamin Tissoires wrote:
> 
> > Hi guys,
> > 
> > this is the v2 of the hid transport cleanup.
> > 
> > Changes since v1:
> > - gathered reviewed/acked/etc..
> > - changed commit messages of patches 4-6
> > - add newcomer into account (thingm)
> > - incorporated the i2c-hid driver change into the series
> > 
> > I still did not implemented the final usb cleanup for hid-multitouch as it may
> > required few comments.
> 
> I have now taken the series. Thanks Benjamin, thanks Henrik.

Thanks Jiri, thanks Benjamin. :-)

Henrik
