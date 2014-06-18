Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965252AbaFRI36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:29:58 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:10796 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933210AbaFRI3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:29:54 -0400
X-IronPort-AV: E=Sophos;i="5.00,730,1396972800"; 
   d="scan'208";a="32080028"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
CC: containers <containers@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Oleg Nesterov" <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>
Subject: RE: [PATCH] ns: introduce getnspid syscall
Thread-Topic: [PATCH] ns: introduce getnspid syscall
Thread-Index: AQHPilnMG4Hd810PeE2XcXM0cM0nWJt2ieog
Date: Wed, 18 Jun 2014 08:29:56 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5483D7@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1403000496-10094-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <CAHO5Pa0SHZXsbT14adxnMYGg6dG0DaMabNoreWAO-JDCCUKmWA@mail.gmail.com>
In-Reply-To: <CAHO5Pa0SHZXsbT14adxnMYGg6dG0DaMabNoreWAO-JDCCUKmWA@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5I8U4XY016395



> -----Original Message-----
> From: mtk.linux.lists@gmail.com [mailto:mtk.linux.lists@gmail.com] On Behalf Of
> Michael Kerrisk
> Sent: Wednesday, June 18, 2014 2:27 AM
> To: Chen, Hanxiao/é™ˆ æ™—éœ„
> Cc: containers; Linux Kernel; Richard Weinberger; Serge Hallyn; Oleg Nesterov;
> David Howells; Eric W. Biederman; Andrew Morton; Al Viro; Linux API; Michael
> Kerrisk-manpages
> Subject: Re: [PATCH] ns: introduce getnspid syscall
> 
> Hello Chen Hanxiao
> 
> On Tue, Jun 17, 2014 at 12:21 PM, Chen Hanxiao
> <chenhanxiao@cn.fujitsu.com> wrote:
> > We need a direct method of getting the pid inside containers.
> > If some issues occurred inside container guest, host user
> > could not know which process is in trouble just by guest pid:
> > the users of container guest only knew the pid inside containers.
> > This will bring obstacle for trouble shooting.
> >
> > int getnspid(pid_t pid, int fd1, int fd2, int pidtype);
> 
> Please CC linux-api@vger.kernel.org on all patches that change the API
> that the kernel presents to user space. See
> https://www.kernel.org/doc/man-pages/linux-api-ml.html
> 
> Thanks,
> 
> Michael
> 
> 
Thanks for reminding.

- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
