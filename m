Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3LXICa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 03:02:30 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64405 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3LXIC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 03:02:29 -0500
X-AuditID: 9c930197-b7c4aae000003d84-47-52b93f934c44
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCHSET 00/17] tracing/uprobes: Add support for more fetch methods (v9)
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org>
	<20131223180026.GA4696@redhat.com>
Date: Tue, 24 Dec 2013 17:02:27 +0900
In-Reply-To: <20131223180026.GA4696@redhat.com> (Oleg Nesterov's message of
	"Mon, 23 Dec 2013 19:00:26 +0100")
Message-ID: <87ppomfzho.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Mon, 23 Dec 2013 19:00:26 +0100, Oleg Nesterov wrote:
> On 12/16, Namhyung Kim wrote:
>>
>> This patchset implements memory (address), stack[N], deference,
>> bitfield, retval (it needs uretprobe tho) and file_offset fetch
>> methods for uprobes.  It's based on the previous work [1] done by
>> Hyeoncheol Lee.
>
> I can't say I understand every change in details, but everything looks
> fine to me. And this series addresses all my previous comments.
>
> FWIW,
>
> Acked-by: Oleg Nesterov <oleg@redhat.com>

Thank you so much for your review!! :)
Namhyung
