Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaA1PVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:21:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbaA1PVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:21:52 -0500
Date: Tue, 28 Jan 2014 16:21:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Reyad Attiyat <reyad.attiyat@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: Re: [PATCH] hid-microsoft: Add ID's for Surface Type/Touch Cover 2
In-Reply-To: <52E021E8.8060608@gmail.com>
Message-ID: <alpine.LNX.2.00.1401281620580.3763@pobox.suse.cz>
References: <52E021E8.8060608@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014, Reyad Attiyat wrote:

> This patch fixes bug 64811 (https://bugzilla.kernel.org/show_bug.cgi?id=64811)
> The Microsoft Surface Type/Touch cover 2 devices have the flag
> HID_DG_CONTACTID in their reports.This causes the device to bind to the
> hid-multitouch driver, which doesn't handle generic keyboard/mouse input
> events.
> The patch adds the hardware id's of the device to hid-microsoft and to the HID
> special driver array, which makes the device get handled by
> hid-generic/hid-input properly.
> 
> Singed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
> Reviewed-by: Benjamin Tissoires<benjamin.tissoires@redhat.com>

I have now applied the patch.

Please fix your mail client for your next submissions so that it doesn't 
whitespace-damage the patches.

I have fixed it now by hand. See Documentation/email-clients.txt for some 
hints on how to do this properly next time.

Thanks,

-- 
Jiri Kosina
SUSE Labs
