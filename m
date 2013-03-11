Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3CKPxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:53:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23791 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3CKPxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:53:07 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=4tJu7dT1YMoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=1YWbut8buxUA:10 a=VwQbUJbxAAAA:8 a=t2dSz0Cs3JsyNU80n04A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363017185.12608.21.camel@gandalf.local.home>
Subject: Re: [PATCH 12/13] scsi/tracing: include correct header file
From: Steven Rostedt <rostedt@goodmis.org>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 11 Mar 2013 11:53:05 -0400
In-Reply-To: <CACV3sbJi-1S_yWbJWL5u6j6HN6ej_R8=FsH2txmEYGM5AfauoQ@mail.gmail.com>
References: <513D844D.7000301@huawei.com>
	 <1363011675.12608.14.camel@gandalf.local.home>
	 <1363015456.2395.80.camel@dabdike.int.hansenpartnership.com>
	 <1363016174.12608.20.camel@gandalf.local.home>
	 <CACV3sbJi-1S_yWbJWL5u6j6HN6ej_R8=FsH2txmEYGM5AfauoQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 23:45 +0800, Jovi Zhang wrote:

> Thanks, sometimes I forgot cc mailing list in MAINTAINERS file(just
> attention on M),
> I will got this in next patch submission.

Note, the patches I said were fine, please do not resend. I'll take them
as is.

> 
> I will resend those two patches with Cc linux-scsi@vger.kernel.org

Send them as their own patch set. They do not need to be included with
the others.

-- Steve



