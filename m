Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaBHN6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 08:58:41 -0500
Received: from infra.glanzmann.de ([88.198.249.254]:60765 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaBHN6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 08:58:40 -0500
Date: Sat, 8 Feb 2014 14:58:38 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Ogness <john.ogness@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        Linux Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: REGRESSION f54b311142a92ea2e42598e347b84e1655caf8e3 tcp auto
 corking slows down iSCSI file system creation by factor of 70 [WAS: 4 TB
 VMFS creation takes 15 minutes vs 26 seconds]
Message-ID: <20140208135838.GC20512@glanzmann.de>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	John Ogness <john.ogness@linutronix.de>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	target-devel <target-devel@vger.kernel.org>,
	Linux Network Development <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140206153640.GB4103@glanzmann.de>
 <1391727771.14985.41.camel@haakon3.risingtidesystems.com>
 <20140207051500.GB10916@glanzmann.de>
 <20140207075536.GB17815@glanzmann.de>
 <1391801597.1155.28.camel@haakon3.risingtidesystems.com>
 <20140207205142.GA8609@glanzmann.de>
 <20140208093808.GD16336@glanzmann.de>
 <1391865273.10160.76.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140208133744.GA20512@glanzmann.de>
 <1391867614.10160.89.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391867614.10160.89.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

> What is your NIC model and driver?

I have four Intel Corporation I350 Gigabit Network Connection (rev 01).

(node-62) [~/work/linux-2.6] lspci -v | pbot
http://pbot.rmdir.de/rgu6yHMBDVQpflMmbcJACg
(node-62) [~/work/linux-2.6] ip a s | pbot
http://pbot.rmdir.de/xJjRT8u-ekC6mrWgl09ZtQ
(node-62) [~/work/linux-2.6] dmesg | pbot
http://pbot.rmdir.de/MigrSPtxGmp0fI1CRgXsHw

I do 802.3ad link aggregation layer 2 hash with two network cards to one
switch.

I'm running:
Linux node-62 3.14.0-rc1+ #23 SMP Sat Feb 8 14:27:47 CET 2014 x86_64 GNU/Linux

Driver: igb

If you need remote access to the machine let me know.

Cheers,
        Thomas
