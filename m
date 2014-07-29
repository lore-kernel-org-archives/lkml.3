Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaG2LGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:06:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbaG2LGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:06:54 -0400
Date: Tue, 29 Jul 2014 13:06:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Reyad Attiyat <reyad.attiyat@gmail.com>
cc: linux-input@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: usbhid: Use flag HID_DISCONNECTED when a usb device
 is removed
In-Reply-To: <1406265181-4009-1-git-send-email-reyad.attiyat@gmail.com>
Message-ID: <alpine.LNX.2.00.1407291303570.16390@pobox.suse.cz>
References: <1406265181-4009-1-git-send-email-reyad.attiyat@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014, Reyad Attiyat wrote:

> Set disconnected flag in struct usbhid when a usb device
> is removed. Check for disconnected flag before sending urb
> requests. This prevents a kernel panic when a hid driver calls
> hid_hw_request() after removing a usb device.
> 
> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>

I've included the full oops output into the changelog and applied, thanks.

-- 
Jiri Kosina
SUSE Labs
