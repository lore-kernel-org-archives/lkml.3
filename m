Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3CKPgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:36:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5420 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab3CKPgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:36:16 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=4tJu7dT1YMoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=1YWbut8buxUA:10 a=VwQbUJbxAAAA:8 a=tmtSDGaQAAAA:8 a=Rmc8GyHxzC3PCNu-YJYA:9 a=PUjeQqilurYA:10 a=jkObVMfX7fAA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363016174.12608.20.camel@gandalf.local.home>
Subject: Re: [PATCH 12/13] scsi/tracing: include correct header file
From: Steven Rostedt <rostedt@goodmis.org>
To: James Bottomley <jbottomley@parallels.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 11 Mar 2013 11:36:14 -0400
In-Reply-To: <1363015456.2395.80.camel@dabdike.int.hansenpartnership.com>
References: <513D844D.7000301@huawei.com>
	 <1363011675.12608.14.camel@gandalf.local.home>
	 <1363015456.2395.80.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 15:24 +0000, James Bottomley wrote:

> > In the future, send them as a separate patch series. There's no
> > dependencies on these patches with the rest of the series. They should
> > have been sent directly to James, with me as the Cc.
> 
> Actually, if you want them applied, they need to go to the SCSI list
> <linux-scsi@vger.kernel.org>.  It tracks all my pending patches.  Stuff
> to me personally has a high probability of getting forgotten.

Zhangwei,

As you may be sending patches to other maintainers, please read the
MAINTAINERS file and send appropriate patches in a separate series to
them as directed:

SCSI SUBSYSTEM
M:      "James E.J. Bottomley" <JBottomley@parallels.com>
L:      linux-scsi@vger.kernel.org
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
S:      Maintained
F:      drivers/scsi/
F:      include/scsi/

Cc the listed maintainers, as well as the listed "L:" lists.

-- Steve


