Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab3BEAhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 19:37:48 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:36139 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114Ab3BEAhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 19:37:45 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Avinash Patil <patila@marvell.com>, Kiran Divekar <dkiran@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 4 Feb 2013 16:36:46 -0800
Subject: RE: [ 014/128] mwifiex: wakeup and stop multiple tx queues in
 net_device
Thread-Topic: [ 014/128] mwifiex: wakeup and stop multiple tx queues in
 net_device
Thread-Index: Ac4DMTGIkP1QTFUUTi6zW4HDfnOQggABQsaw
Message-ID: <477F20668A386D41ADCC57781B1F70430D1432F6DE@SC-VEXCH1.marvell.com>
References: <20130203144644.035172954@decadent.org.uk>
	 <20130203144645.292616915@decadent.org.uk>
	 <477F20668A386D41ADCC57781B1F70430D1432F5B8@SC-VEXCH1.marvell.com>
 <1360021291.4538.19.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1360021291.4538.19.camel@deadeye.wl.decadent.org.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r150bugr011613

Hi Ben,

> On Mon, 2013-02-04 at 11:43 -0800, Bing Zhao wrote:
> > Hi Ben,
> >
> > > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > >
> > > ------------------
> > >
> > > From: Avinash Patil <patila@marvell.com>
> > >
> > > commit bbea3bc432dc5c08d09ca5c80afdd82515470688 upstream.
> >
> > This patch is not for stable kernel.
> [...]
> 
> Right, I've managed to pick up 3 changes to mwifiex that it looks like I
> shouldn't have included.  Firstly:
> 
> 9c969d8ccb1e mwifiex: check wait_event_interruptible return value
> 
> This had "3.6+" to the left of <stable@vger.kernel.org>, whereas I
> expect version qualifiers to be on the right.  So my import script just
> put this in the queue without asking me to interpret the version
> qualifier.  (I don't automate *that* because people use too wide a
> variety of syntaxes.)

Sorry. From now on I will put version qualifiers on the right side of <stable@vger...>

> 
> When trying to apply that, I found that it seemed to depend on these
> two:
> 
> bbea3bc432dc mwifiex: wakeup and stop multiple tx queues in net_device

I'd rather classify this patch as an enhancement because the code change is relatively large.
To play it safe, let's drop this patch from -stable.

> b7097eb75fa1 mwifiex: handle association failure case correctly

This is a bug fix indeed.

> 
> which also looked like they were important fixes.  Presumably I should
> drop all of those?

Please drop bbea3bc432dc only.

I can resend a backport of "b7097eb75fa1 mwifiex: handle association failure case correctly" for 3.2-stable.

Thanks,
Bing
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
