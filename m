Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaJUJzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:55:40 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:16822 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754533AbaJUJzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:55:39 -0400
X-IronPort-AV: E=Sophos;i="5.04,761,1406563200"; 
   d="scan'208";a="37652687"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, Mateusz Guzik <mguzik@redhat.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: RE: [PATCHv5] procfs: show hierarchy of pid namespace
Thread-Topic: [PATCHv5] procfs: show hierarchy of pid namespace
Thread-Index: AQHP6TkKDEPssT3zDUibRSbqcVIu2Jw6Ud4A
Date: Tue, 21 Oct 2014 09:55:39 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5F6039@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1413460916-2852-1-git-send-email-chenhanxiao@cn.fujitsu.com>
In-Reply-To: <1413460916-2852-1-git-send-email-chenhanxiao@cn.fujitsu.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9L9tjfJ030936



> -----Original Message-----
> From: containers-bounces@lists.linux-foundation.org
> [mailto:containers-bounces@lists.linux-foundation.org] On Behalf Of Chen
> Hanxiao
> Sent: Thursday, October 16, 2014 8:02 PM
> To: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> Cc: Richard Weinberger; Serge Hallyn; Oleg Nesterov; Mateusz Guzik; David Howells;
> Eric W. Biederman
> Subject: [PATCHv5] procfs: show hierarchy of pid namespace
> 
> We lack of pid hierarchy information, and this will lead to:
> a) we don't know pids' relationship, who is whose child:
>    /proc/PID/ns/pid only tell us whether two pids live in same ns;
> b) bring trouble to nested lxc container check/restore/migration
> c) bring trouble to pid translation between containers;
> 
> This patch will show the hierarchy of pid namespace
> by pidns_hierarchy like:
> 

Any comments?

Thanks,
- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
