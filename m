Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab3HEIri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:47:38 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63041 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab3HEIrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:47:37 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-4a-51ff66a7cbda
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 09/13] tracing/uprobes: Fix a comment for uprobe registration syntax
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org>
	<1375261410-11219-10-git-send-email-namhyung@kernel.org>
	<51FF3F5F.7030706@hitachi.com>
Date: Mon, 05 Aug 2013 17:47:35 +0900
In-Reply-To: <51FF3F5F.7030706@hitachi.com> (Masami Hiramatsu's message of
	"Mon, 05 Aug 2013 14:59:59 +0900")
Message-ID: <8761vk1q3c.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Aug 2013 14:59:59 +0900, Masami Hiramatsu wrote:
> (2013/07/31 18:03), Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The uprobe syntax requires an offset after a file path not a symbol.
>
> Is this a bugfix? If so, IMHO, it should be applied earlier in the series.
>
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

I'm not sure it should be treated as a bugfix.  Waiting for other's opinion.

Thanks,
Namhyung
