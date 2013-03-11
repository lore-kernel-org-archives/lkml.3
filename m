Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3CKPpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:45:47 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:35720 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab3CKPpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:45:45 -0400
MIME-Version: 1.0
In-Reply-To: <1363016174.12608.20.camel@gandalf.local.home>
References: <513D844D.7000301@huawei.com>
	<1363011675.12608.14.camel@gandalf.local.home>
	<1363015456.2395.80.camel@dabdike.int.hansenpartnership.com>
	<1363016174.12608.20.camel@gandalf.local.home>
Date: Mon, 11 Mar 2013 23:45:44 +0800
Message-ID: <CACV3sbJi-1S_yWbJWL5u6j6HN6ej_R8=FsH2txmEYGM5AfauoQ@mail.gmail.com>
Subject: Re: [PATCH 12/13] scsi/tracing: include correct header file
From: Jovi Zhang <bookjovi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: James Bottomley <jbottomley@parallels.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 11:36 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2013-03-11 at 15:24 +0000, James Bottomley wrote:
>
>> > In the future, send them as a separate patch series. There's no
>> > dependencies on these patches with the rest of the series. They should
>> > have been sent directly to James, with me as the Cc.
>>
>> Actually, if you want them applied, they need to go to the SCSI list
>> <linux-scsi@vger.kernel.org>.  It tracks all my pending patches.  Stuff
>> to me personally has a high probability of getting forgotten.
>
> Zhangwei,
>
> As you may be sending patches to other maintainers, please read the
> MAINTAINERS file and send appropriate patches in a separate series to
> them as directed:
>
> SCSI SUBSYSTEM
> M:      "James E.J. Bottomley" <JBottomley@parallels.com>
> L:      linux-scsi@vger.kernel.org
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
> S:      Maintained
> F:      drivers/scsi/
> F:      include/scsi/
>
> Cc the listed maintainers, as well as the listed "L:" lists.
>
Thanks, sometimes I forgot cc mailing list in MAINTAINERS file(just
attention on M),
I will got this in next patch submission.

I will resend those two patches with Cc linux-scsi@vger.kernel.org
> -- Steve
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
