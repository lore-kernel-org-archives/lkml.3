Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3A2U2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:28:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52038 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3A2U2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:28:51 -0500
Date: Tue, 29 Jan 2013 21:28:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: x86@kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Message-ID: <20130129202848.GE25415@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is rc5 + tip/master from 2 days ago, when resuming I get this fun
message:

...
[15117.684975] Restarting tasks ... done.
[15117.687201] video LNXVIDEO:00: Restoring backlight state
[15117.720469] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
[15117.721414] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3cold
[15117.949185] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[15118.617192] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[15118.617198] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
[15123.971346] Uhhuh. NMI received for unknown reason 2c on CPU 0.
[15123.971353] Do you have a strange power saving mode enabled?
[15123.971356] Dazed and confused, but trying to continue

Machine is thinkpad x230. Any and all sensible suggestions are welcome.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
