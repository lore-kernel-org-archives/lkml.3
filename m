Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3LHMGJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 07:06:09 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:38507 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab3LHMGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 07:06:05 -0500
X-Greylist: delayed 836 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Dec 2013 07:06:05 EST
Message-ID: <52A45D63.5060100@xs4all.nl>
Date: Sun, 08 Dec 2013 12:52:03 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: xhci_hcd debugging status, please?
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Can someone please summarise the status of the xhci_hcd debugging I
found after booting into 3.12.2?
I did not see these messages before and I do not yet understand the
added value for a mere user of this exciting xhci technology.
Can we please have them go away if really there's noting really wrong?
See below for a small part of the stream of stuff that was started.

Kind regards,
Udo

[336894.944861] xhci_hcd 0000:00:10.1: Removing canceled TD starting at
0x25f450 (dma).
[336894.944866] xhci_hcd 0000:00:10.1: TRB to noop at offset 0x25f450
[336894.944885] xhci_hcd 0000:00:10.1: Cancel URB ffff8802342fa080, dev
1.1.4, ep 0x81, starting at offset 0x25f460
[336894.944890] xhci_hcd 0000:00:10.1: // Ding dong!
[336894.944977] xhci_hcd 0000:00:10.1: Removing canceled TD starting at
0x25f460 (dma).
[336894.944981] xhci_hcd 0000:00:10.1: TRB to noop at offset 0x25f460
