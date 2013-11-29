Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab3K2QuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 11:50:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352Ab3K2QuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 11:50:20 -0500
Date: Fri, 29 Nov 2013 17:51:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH/RFC 17/17] tracing/uprobes: Add @+file_offset fetch
	method
Message-ID: <20131129165106.GA5224@redhat.com>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org> <1385533203-10014-18-git-send-email-namhyung@kernel.org> <20131127185546.GA30544@redhat.com> <877gbtq7rb.fsf@sejong.aot.lge.com> <20131128163148.GA15985@redhat.com> <87ob54oxzt.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob54oxzt.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On 11/29, Namhyung Kim wrote:
>
> Hi Oleg,
>
> On Thu, 28 Nov 2013 17:31:48 +0100, Oleg Nesterov wrote:
> > On 11/28, Namhyung Kim wrote:
> >>
> >> I thought we need a fetch_param anyway if we will add support for
> >> cross-fetch later.  But I won't insist it strongly, I can delay it to
> >> later work and make current code simpler if you want. :)
> >
> > OK, great,
>
> So do you want me to change to make it simpler without a fetch_param?

Yes, yes. Assuming that you agree, of course.

Oleg.

