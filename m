Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaKJMFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:05:48 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:48660 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaKJMFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:05:47 -0500
MIME-Version: 1.0
X-Originating-IP: [80.246.32.33]
In-Reply-To: <545C80F4.4020905@hitachi.com>
References: <20141102105006.21708.28734.stgit@hemant-fedora>
	<20141102105557.21708.19032.stgit@hemant-fedora>
	<87lhnr5sbl.fsf@sejong.aot.lge.com>
	<54588905.7040002@linux.vnet.ibm.com>
	<5458CD15.4010101@hitachi.com>
	<874muew2hk.fsf@sejong.aot.lge.com>
	<5459E865.6050207@hitachi.com>
	<545B1DDE.9000202@linux.vnet.ibm.com>
	<545C80F4.4020905@hitachi.com>
Date: Mon, 10 Nov 2014 13:05:45 +0100
Message-ID: <CAPh34mfj5DJSbUBhQSZS_QpTUubV5a7UEsiyzfNSia3bjU2kww@mail.gmail.com>
Subject: Re: [RFC] perf-cache command interface design
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2014 09:21, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:

> File Format
> ===========
> All the cache files are placed under ~/.debug/ by default.
> The paths of buildid cache of binary/symbols are not changed.
>
> The SDT/probe caches are placed under the ~/.debug/.probes/path/to/bin/bu/ildid
> and that is linked to ~/.debug/.probes/.buildid/bu/ildid
> # To avoid conflict with files under /probes/*, I picked up .probes/.

A little bit late: but why ~/.debug? Why not $XDG_CACHE_HOME/perf/ as
the root for all perf related files? debug is not unique nor is it sufficient
to meet file hierarchy: man file-hierarchy(8)

Hagen
