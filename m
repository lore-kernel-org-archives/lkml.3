Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaILBy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 21:54:26 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:51145 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751744AbaILByZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 21:54:25 -0400
X-IronPort-AV: E=Sophos;i="5.04,509,1406563200"; 
   d="scan'208";a="35846782"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: Aristeu Rozanski <aris@redhat.com>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabian Frederick <fabf@skynet.be>,
        "Serge Hallyn" <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: RE: [RESEND][PATCH] userns: use marco instead of magic number for
 max userns level
Thread-Topic: [RESEND][PATCH] userns: use marco instead of magic number for
 max userns level
Thread-Index: AQHPzey0KZ97+N/QhkenTfTr3cFg2Zv8u+XQ
Date: Fri, 12 Sep 2014 01:54:14 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5A2A4E@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1410429091-7234-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <20140911181741.GU22290@redhat.com>
In-Reply-To: <20140911181741.GU22290@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8C1sUXs030402



> -----Original Message-----
> From: Aristeu Rozanski [mailto:aris@redhat.com]
> 
> On Thu, Sep 11, 2014 at 05:51:31PM +0800, Chen Hanxiao wrote:
> > Use marco instead of magic number
> > for max user namespace level.
> 
> patch is ok, but you might want to do s/marco/macro/
> 
Sorry for that typo..
Do I need to resend it?

Thanks,
- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
