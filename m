Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbaIEHZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:25:12 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:7609 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751711AbaIEHZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:25:10 -0400
X-IronPort-AV: E=Sophos;i="5.04,471,1406563200"; 
   d="scan'208";a="35556630"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 0/3] ns,	procfs: pid conversion between ns and
 showing pidns hierarchy
Thread-Topic: [RFC PATCH 0/3] ns,	procfs: pid conversion between ns and
 showing pidns hierarchy
Thread-Index: AQHPx2H9DvwO+a+cxEefAjIMouBVhZvxwfCA
Date: Fri, 5 Sep 2014 05:21:47 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E59172F@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
In-Reply-To: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s857PIKf015327

Hi,

> -----Original Message-----
> Quoting Chen Hanxiao (chenhanxiao@cn.fujitsu.com):
> > This series will expose pid inside containers
> > via procfs.
> > Also show the hierarchy of pid namespcae.
> > Then we could know how pid looks inside a container
> > and their ns relationships.
> > 
> > Chen Hanxiao (3):
> >   procfs: check uniq proc_dir_entry subdir name
> >   procfs: show hierarchy of pid namespace
> >   /proc/pid/status: show all sets of pid according to ns
> > 
> >  fs/proc/Kconfig           |   6 ++
> >  fs/proc/Makefile          |   1 +
> >  fs/proc/array.c           |  17 +++++
> >  fs/proc/generic.c         |  15 +++++
> >  fs/proc/pidns_hierarchy.c | 161 ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/proc_fs.h   |   3 +
> >  6 files changed, 203 insertions(+)
> >  create mode 100644 fs/proc/pidns_hierarchy.c
> 
>Thanks, Chen.  I'm sorry I won't have a chance to review this week, but
>hope to do next week.
>

Thanks for your time and kindly help.

-Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
