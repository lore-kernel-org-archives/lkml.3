Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab3BPRlN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 12:41:13 -0500
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52512 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3BPRlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 12:41:12 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Feb 2013 12:41:12 EST
Date: Sat, 16 Feb 2013 18:33:50 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Frederik Himpe <fhimpe@vub.ac.be>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        sarah.a.sharp@linux.intel.com
Subject: Re: xhci module fails when booting in UEFI mode
Message-ID: <20130216173350.GA4821@hardeman.nu>
Mail-Followup-To: Frederik Himpe <fhimpe@vub.ac.be>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	sarah.a.sharp@linux.intel.com
References: <kcm7tc$aom$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <kcm7tc$aom$1@ger.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 11:15:56AM +0000, Frederik Himpe wrote:
>I've got a HP EliteBook 8470p on which I installed Debian Wheezy in UEFI 
>mode. With both the 3.2 kernel from Wheezy, as the 3.7.1 kernel from 
>experimental, xhci fails to initialize and my USB mouse connected to one 
>of these ports is not recognized at all. The USB3 ports work fine in 
>Windows.
>
>[    1.316248] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
>[    1.316251] xhci_hcd 0000:00:14.0: PCI INT A: no GSI
>[    1.316253] 
>[    1.316277] xhci_hcd 0000:00:14.0: setting latency timer to 64
>[    1.316281] xhci_hcd 0000:00:14.0: xHCI Host Controller
>[    1.316287] xhci_hcd 0000:00:14.0: new USB bus registered, assigned 
>bus number 1
>[    1.316393] xhci_hcd 0000:00:14.0: cache line size of 64 is not 
>supported
>[    1.316395] xhci_hcd 0000:00:14.0: request interrupt 255 failed
>[    1.316447] xhci_hcd 0000:00:14.0: USB bus 1 deregistered
>[    1.316466] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
>[    1.316467] xhci_hcd 0000:00:14.0: init 0000:00:14.0 fail, -22
>[    1.316505] xhci_hcd: probe of 0000:00:14.0 failed with error -22
>
>Full dmesg, lspci, lsusb and lsmod can be found here:
>http://artipc10.vub.ac.be/~frederik/uefi-xhci/
>
>I found this report about the same problem on a HP Probook system: 
>https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1072918 

I have the same problem (HP Elitebook 8570p in my case).

This thread seems related:
https://lkml.org/lkml/2012/2/13/453

No idea what happened to the patches in that thread though...


-- 
David Härdeman
