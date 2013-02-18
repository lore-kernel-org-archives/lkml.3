Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3BRUse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 15:48:34 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:33981 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3BRUsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 15:48:32 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgNDAHKSIlFV5qjOPGdsb2JhbABEiwC1I4EDFwMBAQEBODSCHwEBBAE6HCMFCwgDDhMlDwUlChqIHwrBExWNWoFIB4JfYQOWK4YBjWCBcQ
X-IronPort-AV: E=Sophos;i="4.84,690,1355094000"; 
   d="scan'208";a="278833801"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 18 Feb 2013 21:49:41 +0100
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] hid driver transport cleanup
Message-ID: <20130218204941.GA12214@polaris.bitmath.org>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
 <alpine.LNX.2.00.1302181012320.17024@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1302181012320.17024@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > so, here is the hid drivers cleanup. The aim is to remove as much as possible
> > direct calls to usbhid for hid drivers. Thus, other transport layers can use
> > the existing hid drivers (like I2C or uhid).
> > 
> > Henrik, patches 1 to 5 are yours. I just rebased and double-checked them. Please
> > add you Signed-off-by if you are happy with the rebase.
> 
> Henrik,
> 
> I can see your signoff in my inbox only for patches 1 and 2. Are you still 
> reviewing patches 3-5?

Yes, unfortunately the pipe is pretty full.

> Also, I'd like to make sure that we don't mess up the authorship, so 
> patches 1-5 should be applied with Henrik's authorship, right? (I can do 
> it after I receive signoffs from Henrik for those).

Benjamin has gone through the effort of keeping the patches
up-to-date, so I don't mind him being the author on most of
them. Maybe the first patch is actually identical to my earlier
submission, at least I seem to have it in my computer. :-)

Thanks,
Henrik
