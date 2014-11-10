Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaKJNhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:37:20 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:53208 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaKJNhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:37:18 -0500
MIME-Version: 1.0
X-Originating-IP: [80.246.32.33]
In-Reply-To: <20141110125021.GP3337@twins.programming.kicks-ass.net>
References: <20141102105006.21708.28734.stgit@hemant-fedora>
	<20141102105557.21708.19032.stgit@hemant-fedora>
	<87lhnr5sbl.fsf@sejong.aot.lge.com>
	<54588905.7040002@linux.vnet.ibm.com>
	<5458CD15.4010101@hitachi.com>
	<874muew2hk.fsf@sejong.aot.lge.com>
	<5459E865.6050207@hitachi.com>
	<545B1DDE.9000202@linux.vnet.ibm.com>
	<545C80F4.4020905@hitachi.com>
	<CAPh34mfj5DJSbUBhQSZS_QpTUubV5a7UEsiyzfNSia3bjU2kww@mail.gmail.com>
	<20141110125021.GP3337@twins.programming.kicks-ass.net>
Date: Mon, 10 Nov 2014 14:37:16 +0100
Message-ID: <CAPh34mdr=AVoPBprcgt+dPW8yzGzTf5K838dz3caiSAPry8D7w@mail.gmail.com>
Subject: Re: [RFC] perf-cache command interface design
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 November 2014 13:50, Peter Zijlstra <peterz@infradead.org> wrote:

> # env | grep XDG | wc -l
> 0
>
> Which renders it useless crap in my book.
>
> I agree on the .debug name being somewhat generic, also, it would be:
> man 8 file-hierarchy, but that too fails:
>
> $ man file-hierarchy
> No manual entry for file-hierarchy

Ok, but then we are not even consistent to ourself, see "perf: Add
support for full Intel event lists" which download already to
$XDG_CACHE_HOME [1]. It is not useless to agree on one standard.
Reinvent the place where caches and configurations are stored again
and again is somewhat stupid. E.g. ~/.cache (or $XDG_CACHE_HOME) can
be deleted without problems, ~/.config not, and so on. Someone
(Rusty?) thought about this several years ago, IMHO we should give at
least a try.

Hagen

[1] https://lkml.org/lkml/2014/7/30/686
