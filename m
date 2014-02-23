Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaBWBWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 20:22:34 -0500
Received: from mail.wdtv.com ([66.118.69.84]:34592 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbaBWBWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 20:22:32 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: It BOOTS! 3.13.5 that is.
Date: Sat, 22 Feb 2014 20:22:20 -0500
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201402222022.20370.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But my tv card isn't being found by kaffeine.  It is this card:

01:08.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
	Subsystem: pcHDTV Device 3000
	Flags: bus master, medium devsel, latency 32, IRQ 10
	Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [44] Vital Product Data <?>
	Capabilities: [4c] Power Management version 2

01:08.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
	Subsystem: pcHDTV Device 3000
	Flags: bus master, medium devsel, latency 32, IRQ 10
	Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2

>From an lspci

In a make xconfig, I cannot find this specific card in the list of DVB 
front ends.  What modules do I need to make sure are being built?

Thanks.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

