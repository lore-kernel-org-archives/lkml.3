Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934610AbaGXUZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:25:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55953 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXUZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:25:53 -0400
Date: Thu, 24 Jul 2014 13:25:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v2 23/23] Input - wacom: Move the USB (now hid) Wacom
 driver in drivers/hid
Message-ID: <20140724202548.GD26752@core.coreip.homeip.net>
References: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
 <1405449946-11515-24-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405449946-11515-24-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 02:45:46PM -0400, Benjamin Tissoires wrote:
> wacom.ko is now a full HID driver, we have to move it into the proper
> subdirectory: drivers/hid.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Hmm, this breaks the new wacom_serial4 driver that wants wacom_wac.h. It
looks like it only wants STYLUS_DEVICE_ID, ERASER_DEVICE_ID, and
CURSOR_DEVICE_ID definitions, I think I will just copy them into
wacom_serial4.c and be done with it. Hans?

Thanks.

-- 
Dmitry
