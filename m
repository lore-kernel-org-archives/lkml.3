Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaBHRU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 12:20:27 -0500
Received: from infra.glanzmann.de ([88.198.249.254]:32773 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaBHRUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 12:20:25 -0500
Date: Sat, 8 Feb 2014 18:20:23 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        Linux Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tcp: disable auto corking by default
Message-ID: <20140208172022.GB23798@glanzmann.de>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	target-devel <target-devel@vger.kernel.org>,
	Linux Network Development <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1391727771.14985.41.camel@haakon3.risingtidesystems.com>
 <20140207051500.GB10916@glanzmann.de>
 <20140207075536.GB17815@glanzmann.de>
 <1391801597.1155.28.camel@haakon3.risingtidesystems.com>
 <20140207205142.GA8609@glanzmann.de>
 <20140208091828.GA16336@glanzmann.de>
 <20140208091944.GB16336@glanzmann.de>
 <1391871850.10160.103.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140208165539.GA22359@glanzmann.de>
 <1391879558.10160.112.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391879558.10160.112.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

> Sure, but if we put this flag to zero, nobody will ever use it and
> find any bug.

I agree.

> If we can add the MSG_MORE at the right place, your workload might gain
> ~20% exec time, and maybe 30% better efficiency, since you'll divide by
> 2 the total number of network segments.

That is in fact promising.

> Just to be clear: No stable kernel has yet any issue, right?

Not with TCP CORK as it was recently introduced in the development
branch but it will become stable at one point.

Cheers,
        Thomas
