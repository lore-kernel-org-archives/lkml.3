Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaACBx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 20:53:59 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:15926 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753131AbaACBx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 20:53:58 -0500
Date: Thu, 2 Jan 2014 20:53:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Hyeoncheol Lee" <cheol.lee@lge.com>
Cc: "'Namhyung Kim'" <namhyung@kernel.org>,
        "'Oleg Nesterov'" <oleg@redhat.com>,
        "'Masami Hiramatsu'" <masami.hiramatsu.pt@hitachi.com>,
        "'Srikar Dronamraju'" <srikar@linux.vnet.ibm.com>,
        "'zhangwei\(Jovi\)'" <jovi.zhangwei@huawei.com>,
        "'Arnaldo Carvalho de Melo'" <acme@ghostprotocols.net>,
        "'Hemant Kumar'" <hkshaw@linux.vnet.ibm.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Namhyung Kim'" <namhyung.kim@lge.com>
Subject: Re: [PATCH 15/17] tracing/uprobes: Add support for full argument
 access methods
Message-ID: <20140102205355.1404c689@gandalf.local.home>
In-Reply-To: <002d01cf0821$8ee66300$acb32900$@lge.com>
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org>
	<1387168336-13213-16-git-send-email-namhyung@kernel.org>
	<20140102155827.21b552e0@gandalf.local.home>
	<20140102160218.6e9ee4a4@gandalf.local.home>
	<002d01cf0821$8ee66300$acb32900$@lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014 10:17:23 +0900
"Hyeoncheol Lee" <cheol.lee@lge.com> wrote:

> Patches look good to me.
> 
> Signed-off-by: Hyeoncheol Lee <cheol.lee@lge.com>
> 

Thanks! I'll add this to my queue.

-- Steve
