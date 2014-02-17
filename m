Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaBQP0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:26:51 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47833 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaBQP0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:26:49 -0500
Message-ID: <1392650807.24974.12.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: REGRESSION f54b311142a92ea2e42598e347b84e1655caf8e3 tcp auto
 corking slows down iSCSI file system creation by factor of 70 [WAS: 4 TB
 VMFS creation takes 15 minutes vs 26 seconds]
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Glanzmann <thomas@glanzmann.de>
Cc: John Ogness <john.ogness@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        Linux Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 17 Feb 2014 07:26:47 -0800
In-Reply-To: <20140217140821.GD6211@glanzmann.de>
References: <20140206153640.GB4103@glanzmann.de>
	 <1391727771.14985.41.camel@haakon3.risingtidesystems.com>
	 <20140207051500.GB10916@glanzmann.de> <20140207075536.GB17815@glanzmann.de>
	 <1391801597.1155.28.camel@haakon3.risingtidesystems.com>
	 <20140207205142.GA8609@glanzmann.de> <20140208093808.GD16336@glanzmann.de>
	 <1391865273.10160.76.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140208133744.GA20512@glanzmann.de>
	 <1391868564.10160.91.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140217140821.GD6211@glanzmann.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 15:08 +0100, Thomas Glanzmann wrote:
> Hello Eric,
> may submit your latest patch for upstream? Or do you plan on doing that
> yourself?

Unfortunately you did not had good results with the MSG_MORE applied to
the page fragments.

I think I'll submit the part only dealing with the metadata.

Then later we might take care of the page themselves.


