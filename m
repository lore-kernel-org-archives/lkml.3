Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaH2J7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:59:45 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:11112 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751026AbaH2J7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:59:43 -0400
X-IronPort-AV: E=Sophos;i="5.04,424,1406563200"; 
   d="scan'208";a="35251770"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Richard Weinberger (richard@nod.at)" <richard@nod.at>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "Oleg Nesterov (oleg@redhat.com)" <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman (ebiederm@xmission.com)" <ebiederm@xmission.com>,
        "Vasily Kulikov (segoon@openwall.com)" <segoon@openwall.com>
Subject: RE: [RFC]Pid conversion between pid namespace
Thread-Topic: [RFC]Pid conversion between pid namespace
Thread-Index: AQHPwsb7Dpj7Z/VYf0O7DBvwSeHBf5vnUiMw
Date: Fri, 29 Aug 2014 09:59:40 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E58AD6E@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <5871495633F38949900D2BF2DC04883E55C374@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5871495633F38949900D2BF2DC04883E560412@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5871495633F38949900D2BF2DC04883E56C7A2@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140804222044.GJ12438@ubuntumail>
 <5871495633F38949900D2BF2DC04883E57702E@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140807161141.GG18303@ubuntumail>
 <5871495633F38949900D2BF2DC04883E577E1A@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20140828134957.GA6047@mail.hallyn.com>
In-Reply-To: <20140828134957.GA6047@mail.hallyn.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7T9xn7R024222



> -----Original Message-----
> From: Serge E. Hallyn [mailto:serge@hallyn.com]
> Sent: Thursday, August 28, 2014 9:50 PM
> To: Chen, Hanxiao/é™ˆ æ™—éœ„
> Cc: Serge Hallyn; Richard Weinberger (richard@nod.at);
[snip]

> > > I like your proc approach.  Do you have an implementation?
> >
> > Thanks for your comments.
> > I'm preparing the pidns hierarchy patch.
> > It seems that it's not easy to carry it out.
> 
> :)  Not entirely surprised.
> 
> Please do send patches earlier rather than later to avoid going
> down a path that someone's going to nack anyway.

I've almost finished ns hierarchy patch
and do some tests now.
It will be sent in the next week.

Thanks,
- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
