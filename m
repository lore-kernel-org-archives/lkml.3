Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaKXJr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:47:59 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:7015 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752013AbaKXJr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:47:58 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="43881811"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Pavel Emelyanov (xemul@parallels.com)" <xemul@parallels.com>
CC: Oleg Nesterov <oleg@redhat.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        "David Howells" <dhowells@redhat.com>,
        Richard Weinberger <richard@nod.at>
Subject: RE: [PATCH v8 1/2] procfs: show hierarchy of pid namespace
Thread-Topic: [PATCH v8 1/2] procfs: show hierarchy of pid namespace
Thread-Index: AQHQBQkf3yr0fqs7UUqz1iKFlE8zc5xpkGYAgAXQ4uA=
Date: Mon, 24 Nov 2014 09:47:59 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E73764172@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1416303013-13762-1-git-send-email-chenhanxiao@cn.fujitsu.com>
	<1416303013-13762-2-git-send-email-chenhanxiao@cn.fujitsu.com>
	<5871495633F38949900D2BF2DC04883E73748A47@G08CNEXMBPEKD03.g08.fujitsu.local>
	<546E5D46.4070805@nod.at>
 <20141120142112.74b490298d3360e53dc3169a@linux-foundation.org>
In-Reply-To: <20141120142112.74b490298d3360e53dc3169a@linux-foundation.org>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAO9m62x029257



> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Friday, November 21, 2014 6:21 AM
> To: Richard Weinberger
> Cc: Chen, Hanxiao/³Â êÏÏö; Eric W. Biederman; Serge Hallyn; Oleg Nesterov;
> containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org; Mateusz
> Guzik; David Howells
> Subject: Re: [PATCH v8 1/2] procfs: show hierarchy of pid namespace
> 
> On Thu, 20 Nov 2014 22:29:42 +0100 Richard Weinberger <richard@nod.at> wrote:
> 
> > >
> > > Any comments?
> >
> > FWIW, Acked-by: Richard Weinberer <richard@nod.at>
> >
> > The more challenging question is who will pickup this series?
> > Eric? Andrew?
> 
> I can monkey the patches but I'd very much like to hear Eric's comments.
> 
> Also the CRIU people.  How is CRIU presently reassembling these
> relationships?
> 
> Serge, what was your take on the usefulness/applicability of this work?
> IOW, why the ack?

Thanks for your attention and help.

I'd very much like to hear Eric's comments on this patch too.

Hi, Pavel, could you please provide some ideas from the CRIU's point of view?

> 
> The patchset doesn't touch Documentation/.  That will need to be fixed,
> please.  The new interfaces should be completely described in the
> kernel documentation.

I'll add a documentation patch soon.

> 
> The new code appears to be included when CONFIG_PID_NS=n.  Is there any
> point in doing that?

That code should not be included when CONFIG_PID_NS=n.

Thanks,
- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
