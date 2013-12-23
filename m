Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3LWR77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:59:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3LWR76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:59:58 -0500
Date: Mon, 23 Dec 2013 19:00:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCHSET 00/17] tracing/uprobes: Add support for more fetch
	methods (v9)
Message-ID: <20131223180026.GA4696@redhat.com>
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387168336-13213-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16, Namhyung Kim wrote:
>
> This patchset implements memory (address), stack[N], deference,
> bitfield, retval (it needs uretprobe tho) and file_offset fetch
> methods for uprobes.  It's based on the previous work [1] done by
> Hyeoncheol Lee.

I can't say I understand every change in details, but everything looks
fine to me. And this series addresses all my previous comments.

FWIW,

Acked-by: Oleg Nesterov <oleg@redhat.com>

