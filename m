Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaLIIHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:07:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbaLIIHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:07:21 -0500
Date: Tue, 9 Dec 2014 09:07:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Duggan <aduggan@synaptics.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Amordea Whiteoak <amordea@gmail.com>
Subject: Re: [PATCH] HID: rmi: Check for additional ACM registers appended
 to F11 data report
In-Reply-To: <1418079720-11766-1-git-send-email-aduggan@synaptics.com>
Message-ID: <alpine.LNX.2.00.1412090907010.14413@pobox.suse.cz>
References: <1418079720-11766-1-git-send-email-aduggan@synaptics.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2014, Andrew Duggan wrote:

> If a touchpad reports the F11 data40 register then this indicates that the touchpad reports
> additional ACM (Accidental Contact Mitigation) data after the F11 data in the HID attention
> report. These additional bytes shift the position of the F30 button data causing the driver
> to incorrectly report button state when this functionality is present. This patch accounts
> for the additional data in the report.
> 
> Fixes:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1398533
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>

Applied to hid.git#for-3.19/rmi. Thanks,

-- 
Jiri Kosina
SUSE Labs
