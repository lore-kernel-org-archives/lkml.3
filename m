Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbbAGKDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:03:22 -0500
Received: from mail113-251.mail.alibaba.com ([205.204.113.251]:54142 "EHLO
	us-alimail-mta1.hst.scl.en.alidc.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750835AbbAGKDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:03:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R311e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g03005;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=11;RT=11;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Wang Nan'" <wangnan0@huawei.com>
Cc: <linux@arm.linux.org.uk>, "'Ingo Molnar'" <mingo@redhat.com>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>, <lizefan@huawei.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
References: <043a01d02a5b$44ec45f0$cec4d1d0$@alibaba-inc.com> <54ACFFB6.3040102@huawei.com>
In-Reply-To: <54ACFFB6.3040102@huawei.com>
Subject: RE: [RFC PATCH 09/11] kprobes: core logic of eraly kprobes
Date: Wed, 07 Jan 2015 18:02:07 +0800
Message-ID: <045301d02a60$ff36e8c0$fda4ba40$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIEtj9idETv8rQxsVvdEO6VYoonSQMUtq4inDKuSJA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>
> >> +struct early_kprobe_slot {
> >> +	struct optimized_kprobe op;
> >> +};
> >> +
> > [...]
> >>
> >>  /* Free optimized instructions and optimized_kprobe */
> >> +static int ek_free_early_kprobe(struct early_kprobe_slot *slot);
> >
> > [2] How is it implemented? In subsequent patches?
> >
> 
> It is implemented using macro. Please see patch 7/11 and
> 
> DEFINE_EKPROBE_ALLOC_OPS(struct early_kprobe_slot, early_kprobe, static);
>
What is the reason that it is listed in C file, given that it is done in H already?

