Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaBHOMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 09:12:53 -0500
Received: from infra.glanzmann.de ([88.198.249.254]:60801 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaBHOMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 09:12:51 -0500
Date: Sat, 8 Feb 2014 15:12:49 +0100
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
Message-ID: <20140208141249.GF20512@glanzmann.de>
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
 <1391868564.10160.91.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391868564.10160.91.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

[RESEND: dropped CC accidently]

> 10.101.99.5 or 10.101.0.13?

10.101.99.5 (iSCSI Target)

tcpdump -i bond0.101 -s 0 -w /tmp/tcp_auto_corking_on_patched.pcap host esx-03.v101.campusvl.de

Cheers,
        Thomas
