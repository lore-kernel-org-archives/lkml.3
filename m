Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaBQH61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 02:58:27 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:65464 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaBQH60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 02:58:26 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-88-5301c11fa1be
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt \(Red Hat\)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip v3 03/11] [CLEANUP] perf-probe: Replace line_list with intlist
References: <20140206053201.29635.99095.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
	<20140206053209.29635.81043.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
Date: Mon, 17 Feb 2014 16:58:19 +0900
In-Reply-To: <20140206053209.29635.81043.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
	(Masami Hiramatsu's message of "Thu, 06 Feb 2014 05:32:09 +0000")
Message-ID: <877g8uxjac.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Feb 2014 05:32:09 +0000, Masami Hiramatsu wrote:
> Replace line_list (struct line_node) with intlist for
> reducing similar codes.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
