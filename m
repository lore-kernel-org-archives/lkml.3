Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3KDI77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:59:59 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55292 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3KDI76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:59:58 -0500
X-AuditID: 9c93017d-b7bc7ae000000533-3c-5277620cecd4
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch methods (v6)
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
	<20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com>
Date: Mon, 04 Nov 2013 17:59:56 +0900
In-Reply-To: <87ob60366m.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Mon, 04 Nov 2013 17:46:41 +0900")
Message-ID: <87fvrc35kj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Nov 2013 17:46:41 +0900, Namhyung Kim wrote:
> On Sat, 2 Nov 2013 16:54:58 +0100, Oleg Nesterov wrote:
>> - this only allows to read the data from the same binary.
>
> Right.  This is also an unnecessary restriction.  We should be able to
> access data in other binary.

Hmm.. I guess this gonna be not simple - perhaps it can only be
supported for per-process uprobe with known virtual addresses?

Thanks,
Namhyung
