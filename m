Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaAWAAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:00:01 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:53967 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaAVX77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:59:59 -0500
MIME-Version: 1.0
In-Reply-To: <52DC85A9.4060409@huawei.com>
References: <1389946120-19610-1-git-send-email-namhyung@kernel.org> <52DC85A9.4060409@huawei.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 22 Jan 2014 23:59:39 +0000
X-Google-Sender-Auth: 7sTX707yNGyY7aVwZ6I2MtedbY4
Message-ID: <CAM9d7cg2mtzDLUdGeic=_ojb-SkVugJvxnGdpfatLfKZGOOdrA@mail.gmail.com>
Subject: Re: [PATCHSET 0/5] tracing/uprobes: Support multi buffer and event trigger
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jovi,

On Mon, Jan 20, 2014 at 2:10 AM, zhangwei(Jovi)
<jovi.zhangwei@huawei.com> wrote:
> Hi Namhyung,
>
> On 2014/1/17 16:08, Namhyung Kim wrote:
>> Hello,
>> (Resending with LKML CC'ed)
>>
>> This patchset tries to add support for recent multi buffer and event
>> trigger changes to uprobes.  The multi buffer support patch is an
>> updated version of Zovi's previous patch v6 [1].
>>
>> Zovi, please tell me if you have any update and/or issues with this.
>>
> No more update on [Patch 3/5] from my side.
> Thank you for resending this patch!

Apologies for misspelling your name again, and thanks for the reply. :)

Thanks,
Namhyung
