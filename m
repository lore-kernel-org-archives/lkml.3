Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab3LRUZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:25:59 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:7073 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751870Ab3LRUZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:25:57 -0500
Date: Wed, 18 Dec 2013 15:25:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 10/17] tracing/probes: Move 'symbol' fetch method to
 kprobes
Message-ID: <20131218152553.04c04042@gandalf.local.home>
In-Reply-To: <8738lsgwm2.fsf@sejong.aot.lge.com>
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org>
	<1387168336-13213-11-git-send-email-namhyung@kernel.org>
	<52AEB87D.6020507@hitachi.com>
	<87fvptgpe0.fsf@sejong.aot.lge.com>
	<8738lsgwm2.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013 09:16:37 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Steve,
> 
> Would you please review this and consider merging it?  It seems there's
> no more remaining issue and we want to make a progress on it. :)
> 
> Oleg, Srikar, it'd be great if you could confirm it though.
> 

I'd feel better if we got some feedback from Oleg and Srikar too.

I don't have test code for uprobes, and I have minimal test code for
kprobes. How has this been tested?

-- Steve
