Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3CRNzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:55:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab3CRNzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:55:00 -0400
Date: Mon, 18 Mar 2013 14:54:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, hdegoede@redhat.com
Subject: Re: [PATCH] HID: usbhid: quirk for MSI GX680R led panel
In-Reply-To: <20130318134702.GB11243@hansolo.jdub.homelinux.org>
Message-ID: <alpine.LNX.2.00.1303181454500.9529@pobox.suse.cz>
References: <20130318134702.GB11243@hansolo.jdub.homelinux.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Mar 2013, Josh Boyer wrote:

> This keyboard backlight device causes a 10 second delay to boot.  Add it
> to the quirk list with HID_QUIRK_NO_INIT_REPORTS.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
