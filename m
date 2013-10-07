Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab3JGPHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:07:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711Ab3JGPHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:07:37 -0400
Date: Mon, 7 Oct 2013 17:07:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luosong <android@generaltouch.com>
Subject: Re: [PATCH] HID: multitouch: Fix GeneralTouch products and add more
 PIDs
In-Reply-To: <alpine.LNX.2.00.1310021654240.29701@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1310071707070.29701@pobox.suse.cz>
References: <1380705600-11055-1-git-send-email-benjamin.tissoires@redhat.com> <alpine.LNX.2.00.1310021654240.29701@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Oct 2013, Jiri Kosina wrote:

> On Wed, 2 Oct 2013, Benjamin Tissoires wrote:
> 
> > From: Luosong <android@generaltouch.com>
> > 
> > GeneralTouch products should use the quirk SLOT_IS_CONTACTID
> > instead of SLOT_IS_CONTACTNUMBER.
> > 
> > Adding PIDs 0101,e100,0102,0106,010a from the new products.
> > 
> > Tested on new and older products by GeneralTouch engineers.
> > 
> > Signed-off-by: Luosong <android@generaltouch.com>
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > ---
> > 
> > Hi Luosong,
> > 
> > I took the liberty to rewrite the commit message for it to be
> > more compliant with the kernel rules:
> > - there should be a one line title commit message first,
> > - and the rest should detail the patch, tell how it was tested, etc...
> > 
> > If you could just give our ack on this one, Jiri would be able to take it
> > through his tree.
> 
> Thanks Benjamin.
> 
> Luosong, the patch as sent by Benjamin is properly formatted and contains 
> proper changelog. Please make sure that you fix your patch submission 
> workflow for your next submissions.
> 
> Luosong, please let me know that you are find with applying the patch as 
> Benjamin sent it (with attribution to you and your signoff), and I'll 
> proceed.

Luosong, hello ... ?

-- 
Jiri Kosina
SUSE Labs
