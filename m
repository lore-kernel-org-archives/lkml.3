Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3HTVyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:54:25 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:37853 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3HTVyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:54:23 -0400
Date: Tue, 20 Aug 2013 23:54:19 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Chris Clayton <chris2553@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: Networking problem with 3.11-rc6+
Message-ID: <20130820215419.GA29560@electric-eye.fr.zoreil.com>
References: <5213CB17.5050308@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5213CB17.5050308@googlemail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Clayton <chris2553@gmail.com> :
[...]
> [    0.207094] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
> [    0.207155] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[...]
> [    5.311191] r8169 0000:07:00.0: can't disable ASPM; OS doesn't have ASPM control
[...]
> [   65.181715] [<f8e38000>] rtl8169_interrupt [r8169]
> [   65.181717] Disabling IRQ #17
> 
> Let me know if I can provide any additional information, although to
> be honest, the boot completed and the KDE desktop started up OK, so
> there may not be much else I can provide unless I find that the
> problem is repeatable.

Please don't hesitate if it happens again, even if it can't be reproduced
on demand.

-- 
Ueimor
