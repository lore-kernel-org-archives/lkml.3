Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab3CDVia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:38:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42189 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516Ab3CDVi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:38:29 -0500
Date: Mon, 4 Mar 2013 22:38:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: ibm-acpi-devel@lists.sourceforge.net
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: x230: unhandled HKEY event 0x6050
Message-ID: <20130304213804.GE22274@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	ibm-acpi-devel@lists.sourceforge.net,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I get this in dmesg with 3.9-rc1:

[   12.951434] thinkpad_acpi: unhandled HKEY event 0x6050
[   12.951438] thinkpad_acpi: please report the conditions when this event happened to ibm-acpi-devel@lists.sourceforge.net
[   13.516752] thinkpad_acpi: unknown possible thermal alarm or keyboard event received

when pressing Fn+F8/F9, i.e. the display backlight keys. I'm loading
thinkpad_acpi with brightness_enable=1 and booting the kernel with
"acpi_backlight=vendor" so that the backlight intensity gets controlled
by thinkpad_acpi. But the last maybe shouldn't complain about it, no?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
