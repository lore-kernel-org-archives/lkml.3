Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaBQPcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:32:20 -0500
Received: from infra.glanzmann.de ([88.198.249.254]:45706 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbaBQPcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:32:15 -0500
Date: Mon, 17 Feb 2014 16:32:13 +0100
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
Message-ID: <20140217153213.GA12054@glanzmann.de>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	John Ogness <john.ogness@linutronix.de>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	target-devel <target-devel@vger.kernel.org>,
	Linux Network Development <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140207051500.GB10916@glanzmann.de>
 <20140207075536.GB17815@glanzmann.de>
 <1391801597.1155.28.camel@haakon3.risingtidesystems.com>
 <20140207205142.GA8609@glanzmann.de>
 <20140208093808.GD16336@glanzmann.de>
 <1391865273.10160.76.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140208133744.GA20512@glanzmann.de>
 <1391868564.10160.91.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140217140821.GD6211@glanzmann.de>
 <1392650807.24974.12.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392650807.24974.12.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

> Unfortunately you did not had good results with the MSG_MORE applied
> to the page fragments.

I agree. We should submit only the submit the patch from this message:

Message-ID: <1391886759.10160.114.camel@edumazet-glaptop2.roam.corp.google.com>
http://mid.gmane.org/1391886759.10160.114.camel@edumazet-glaptop2.roam.corp.google.com

> I think I'll submit the part only dealing with the metadata.

May I submit the patch or do you want to do it yourself?

Cheers,
        Thomas
