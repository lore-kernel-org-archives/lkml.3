Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3CRPmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:42:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab3CRPm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:42:28 -0400
Date: Mon, 18 Mar 2013 11:41:43 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, hdegoede@redhat.com
Subject: Re: [PATCH] HID: usbhid: quirk for MSI GX680R led panel
Message-ID: <20130318154143.GE11243@hansolo.jdub.homelinux.org>
References: <20130318134702.GB11243@hansolo.jdub.homelinux.org>
 <alpine.LNX.2.00.1303181454500.9529@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1303181454500.9529@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 02:54:58PM +0100, Jiri Kosina wrote:
> On Mon, 18 Mar 2013, Josh Boyer wrote:
> 
> > This keyboard backlight device causes a 10 second delay to boot.  Add it
> > to the quirk list with HID_QUIRK_NO_INIT_REPORTS.
> 
> Applied, thanks.

Ugh.  Typo in this patch that prevents it from building.  I shall hang
my head in shame and send a fixed v2.  My apologies.

josh
