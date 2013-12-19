Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3LSIys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:54:48 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63300 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3LSIyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:54:47 -0500
X-AuditID: 9c93017d-b7c5eae000004296-96-52b2b455367e
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 10/17] tracing/probes: Move 'symbol' fetch method to kprobes
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org>
	<1387168336-13213-11-git-send-email-namhyung@kernel.org>
	<52AEB87D.6020507@hitachi.com> <87fvptgpe0.fsf@sejong.aot.lge.com>
	<8738lsgwm2.fsf@sejong.aot.lge.com>
	<20131218152553.04c04042@gandalf.local.home>
Date: Thu, 19 Dec 2013 17:54:45 +0900
In-Reply-To: <20131218152553.04c04042@gandalf.local.home> (Steven Rostedt's
	message of "Wed, 18 Dec 2013 15:25:53 -0500")
Message-ID: <878uvhfcfe.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013 15:25:53 -0500, Steven Rostedt wrote:
> I don't have test code for uprobes, and I have minimal test code for
> kprobes. How has this been tested?

Basically I tested it with a very simple example code like in the
description of this patchset and the code in the link below - note that
the argument format was slightly changed to have a prifix of "@+".

  https://lkml.org/lkml/2013/11/5/25

Maybe we need to write more test code.  I'll try to find a way to test
it automatically with the perf tools.

Thanks,
Namhyung
