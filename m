Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbbALJOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:14:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbbALJOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:14:41 -0500
Date: Mon, 12 Jan 2015 10:14:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Duggan <aduggan@synaptics.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH v2 3/3] HID: rmi: Add support for the touchpad in the
 Razer Blade 14 laptop
In-Reply-To: <1420757496-3955-2-git-send-email-aduggan@synaptics.com>
Message-ID: <alpine.LNX.2.00.1501121014310.15299@pobox.suse.cz>
References: <1420757496-3955-1-git-send-email-aduggan@synaptics.com> <1420757496-3955-2-git-send-email-aduggan@synaptics.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2015, Andrew Duggan wrote:

> Have hid-rmi handle all of the Razer Blade HID devices that are part of the
> composite USB device. This will allow hid-rmi to operate the touchpad in rmi
> mode while passing events from the other devices to hid-input.
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>

Applied to for-3.20/rmi, thanks.

-- 
Jiri Kosina
SUSE Labs
