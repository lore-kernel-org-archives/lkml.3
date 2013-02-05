Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3BESpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:45:04 -0500
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:47549 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756239Ab3BESpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:45:00 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Avinash Patil <patila@marvell.com>, Kiran Divekar <dkiran@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 5 Feb 2013 10:44:51 -0800
Subject: RE: [ 014/128] mwifiex: wakeup and stop multiple tx queues in
 net_device
Thread-Topic: [ 014/128] mwifiex: wakeup and stop multiple tx queues in
 net_device
Thread-Index: Ac4DMTGIkP1QTFUUTi6zW4HDfnOQggABQsawACYu2HA=
Message-ID: <477F20668A386D41ADCC57781B1F70430D1432F950@SC-VEXCH1.marvell.com>
References: <20130203144644.035172954@decadent.org.uk>
	 <20130203144645.292616915@decadent.org.uk>
	 <477F20668A386D41ADCC57781B1F70430D1432F5B8@SC-VEXCH1.marvell.com>
 <1360021291.4538.19.camel@deadeye.wl.decadent.org.uk> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r15Ij73o016541

Hi Ben,

> > Right, I've managed to pick up 3 changes to mwifiex that it looks like I
> > shouldn't have included.  Firstly:
> >
> > 9c969d8ccb1e mwifiex: check wait_event_interruptible return value
> >
> > This had "3.6+" to the left of <stable@vger.kernel.org>, whereas I
> > expect version qualifiers to be on the right.  So my import script just
> > put this in the queue without asking me to interpret the version
> > qualifier.  (I don't automate *that* because people use too wide a
> > variety of syntaxes.)
> 
> Sorry. From now on I will put version qualifiers on the right side of <stable@vger...>

I forgot to mention that the upstream patch "9c969d8ccb1e mwifiex: check wait_event_interruptible return value" is also needed for 3.2-stable, and your backport patch [016/128] is correct.

The reason I put "3.6+" instead of "3.2+" for stable is that the upstream patch cannot apply cleanly against kernel versions older than 3.6. It must be back ported.

Thanks,
Bing
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
