Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaDQPOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:14:07 -0400
Received: from fujitsu25.fnanic.fujitsu.com ([192.240.6.15]:56423 "EHLO
	fujitsu25.fnanic.fujitsu.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753306AbaDQPN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:13:56 -0400
From: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Satoru MORIYA <satoru.moriya.br@hitachi.com>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Date: Thu, 17 Apr 2014 08:03:10 -0700
Subject: RE: [PATCH v2] kernel/panic: Add "crash_kexec_post_notifiers"
 option for kdump after panic_notifers
Thread-Topic: [PATCH v2] kernel/panic: Add "crash_kexec_post_notifiers"
 option for kdump after panic_notifers
Thread-Index: Ac9Z6vDiYqU/xcx5QkaB2/1uzXeJZwAYxEEw
Message-ID: <6B2BA408B38BA1478B473C31C3D2074E30986F07FE@SV-EXCHANGE1.Corp.FC.LOCAL>
References: <20140417031250.1150.26322.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140417031250.1150.26322.stgit@ltc230.yrl.intra.hitachi.co.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-17_04:2014-04-17,2014-04-17,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3HFEDHM013820



> -----Original Message-----
> From: Masami Hiramatsu [mailto:masami.hiramatsu.pt@hitachi.com]
> Sent: Wednesday, April 16, 2014 8:13 PM
> To: linux-kernel@vger.kernel.org; Vivek Goyal; Eric Biederman
> Cc: Andrew Morton; Yoshihiro YUNOMAE; Satoru MORIYA; Motohiro Kosaki; Tomoki Sekiyama
> Subject: [PATCH v2] kernel/panic: Add "crash_kexec_post_notifiers" option for kdump after panic_notifers
> 
> Add a "crash_kexec_post_notifiers" option to run kdump after running panic_notifiers and dump kmsg. This can help rare situations
> which kdump drops in failure because of unstable crashed kernel or hardware failure (memory corruption on critical data/code), or
> the 2nd kernel is already broken by the 1st kernel (it's a broken behavior, but who can guarantee that the "crashed" kernel works
> correctly?).
> 
> Usage: add "crash_kexec_post_notifiers" to kernel boot option.
> 
> Note that this actually increases risks of the failure of kdump.
> This option should be set only if you worry about the rare case of kdump failure rather than increasing the chance of success.
> 
> Changes from v1:
>  - Rename late_kdump option to crash_kexec_post_notifiers.
>  - Remove unneeded warning message.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Satoru MORIYA <satoru.moriya.br@hitachi.com>
> Cc: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
> Cc: Tomoki Sekiyama <tomoki.sekiyama@hds.com>

I have no objection.
 Acked-by: KOSAKI Motohiro <Kosaki.motohiro@jp.fujitsu.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
