Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbbALJOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:14:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbbALJOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:14:30 -0500
Date: Mon, 12 Jan 2015 10:14:28 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Duggan <aduggan@synaptics.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH v2 2/3] HID: rmi: Support touchpads with external
 buttons
In-Reply-To: <1420757496-3955-1-git-send-email-aduggan@synaptics.com>
Message-ID: <alpine.LNX.2.00.1501121014220.15299@pobox.suse.cz>
References: <1420757496-3955-1-git-send-email-aduggan@synaptics.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2015, Andrew Duggan wrote:

> The external buttons on HID touchpads are connected as pass through devices and
> button events are not reported in the rmi registers. As a result on these
> devices we need to allow the HID generic desktop button events to be processed
> by hid-input. Unfortunately, there is no way to query the touchpad to determine
> that it has pass through buttons so the RMI_DEVICE_HAS_PHYS_BUTTONS should be
> set manually when adding the device to rmi_id[].
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>

Applied to for-3.20/rmi.

-- 
Jiri Kosina
SUSE Labs
