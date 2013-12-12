Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3LLAxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:53:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:12655 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab3LLAxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:53:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,875,1378882800"; 
   d="scan'208";a="442768355"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "mszeredi@suse.cz" <mszeredi@suse.cz>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [fuse-devel] fuse try to freeze with lock held
Thread-Topic: [fuse-devel] fuse try to freeze with lock held
Thread-Index: AQHO9oanAFh0NTHO3k+GUWiDHA41yJpPuwWA
Date: Thu, 12 Dec 2013 00:53:33 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01BCEE37@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A01BB245D@SHSMSX101.ccr.corp.intel.com>
 <CAJfpeguywUhetMDHJyQp0faAf8h4Ht4f1aNpCss1yF9OndToWg@mail.gmail.com>
In-Reply-To: <CAJfpeguywUhetMDHJyQp0faAf8h4Ht4f1aNpCss1yF9OndToWg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBC0rjLF029444

Hello Miklos,

> -----Original Message-----
> From: Miklos Szeredi [mailto:miklos@szeredi.hu]
> Sent: Wednesday, December 11, 2013 11:35 PM
> To: Liu, Chuansheng
> Cc: mszeredi@suse.cz; fuse-devel@lists.sourceforge.net;
> linux-kernel@vger.kernel.org
> Subject: Re: [fuse-devel] fuse try to freeze with lock held
> 
> On Wed, Nov 27, 2013 at 3:19 AM, Liu, Chuansheng
> <chuansheng.liu@intel.com> wrote:
> > Hit the below warning when enabling the CONFIG_DEBUG_LOCK_ALLOC,
> > __fuse_request_send == >
> > request_wait_answer == >
> > wait_event_freezable == >
> > try_to_freeze()
> >
> > But here the inode->i_mutex is hold yet in vfs_readdir().
> >
> > Could anyone give some help? Thanks.
> >
> 
> Mainline doesn't have wait_event_freezable() in fuse.  What kernel
> variant is this?
> 
Thanks your pointing out, it is my fault since it is not mainline.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
