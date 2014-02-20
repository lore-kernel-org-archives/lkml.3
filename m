Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaBTLHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:07:06 -0500
Received: from marvin.bitraf.no ([77.88.71.251]:59375 "EHLO marvin.bitraf.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbaBTLHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:07:04 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Feb 2014 06:07:04 EST
Date: Thu, 20 Feb 2014 11:58:54 +0100 (CET)
From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Message-ID: <30855636.2.1392893933953.JavaMail.root@zimbra>
Subject: Interrupts from ethX sticking to one core
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [109.247.20.140]
X-Mailer: Zimbra 6.0.14_GA_2928 (ZimbraWebClient - FF3.0 (Mac)/6.0.14_GA_2928)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I'm running a NAT44 gateway on Debian Wheezy, kernel 3.2, and timers from eth[01] sticks to cpu0 even though I've set cpu_affinity to 0f (4 cores). This is a VM on ESXi. Setting affinity to a specific core works, but the kernel doesn't balance interrupts dynamically as I would have hoped it should, even when CPU load is at 95% (mostly soft interrupts). I also tried to install irqbalance without this having any effect. Drive used is e1000 (for the moment, will move to vmxnet3, but afaics from testing on another host, this didn't solve the problem).

Is this a known issue? Any way I can fix this?

Please CC: to me as I'm not on the list

Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt. Det er et elementært imperativ for alle pedagoger å unngå eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilfeller eksisterer adekvate og relevante synonymer på norsk.
