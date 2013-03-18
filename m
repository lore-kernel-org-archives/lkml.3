Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3CRP4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:56:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab3CRP4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:56:39 -0400
Date: Mon, 18 Mar 2013 16:56:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, hdegoede@redhat.com
Subject: Re: [PATCH] HID: usbhid: quirk for MSI GX680R led panel
In-Reply-To: <20130318154143.GE11243@hansolo.jdub.homelinux.org>
Message-ID: <alpine.LNX.2.00.1303181656250.9529@pobox.suse.cz>
References: <20130318134702.GB11243@hansolo.jdub.homelinux.org> <alpine.LNX.2.00.1303181454500.9529@pobox.suse.cz> <20130318154143.GE11243@hansolo.jdub.homelinux.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Mar 2013, Josh Boyer wrote:

> > > This keyboard backlight device causes a 10 second delay to boot.  Add it
> > > to the quirk list with HID_QUIRK_NO_INIT_REPORTS.
> > 
> > Applied, thanks.
> 
> Ugh.  Typo in this patch that prevents it from building.  I shall hang
> my head in shame and send a fixed v2.  My apologies.

I have already fixed that in my tree, no need to resend.

-- 
Jiri Kosina
SUSE Labs
