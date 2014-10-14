Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaJNQq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:46:26 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:40811 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaJNQqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:46:24 -0400
MIME-Version: 1.0
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540BFE97@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
	<20141014111915.GV23154@mwanda>
	<CD2CABCB2C0A0D4682C5F8AD840141540BFD19@HKXPRD3002MB006.064d.mgd.msft.net>
	<CAL7Bo8ESE-=FY0KyQDc2Ne1SfX=fF0Q088jo_j-JpMmQYvArGg@mail.gmail.com>
	<CD2CABCB2C0A0D4682C5F8AD840141540BFE97@HKXPRD3002MB006.064d.mgd.msft.net>
Date: Tue, 14 Oct 2014 17:46:24 +0100
Message-ID: <CAL7Bo8FBBomXS13S6nmHcoGhmqYjbHGjTF=QxstuUSf+eYOhjw@mail.gmail.com>
Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
From: Mike Surcouf <mps.surcouf.lkml@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>The value for TICK_USEC is defined as ((1000000UL + USER_HZ/2) / USER_HZ).
> In my box, it's 10000.
OK got it thanks .  Checked the algorithm OK by me.
Of course you can only adjust clock by a tick (smallest resolution) so
you could be flapping between 2 values so as you say NTP is preferred.
However it may be good enough for some scenarios.
