Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaDOIdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:33:47 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:53849 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaDOIdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:33:45 -0400
MIME-Version: 1.0
In-Reply-To: <534CED5B.2090100@hitachi.com>
References: <1397472050-19947-1-git-send-email-nasa4836@gmail.com>
 <534BF7FE.6050603@hitachi.com> <CAHz2CGV_WA_bMwYCg1QCyFpCv0PKgPhBQUf_pFQbNn-guLL+Ag@mail.gmail.com>
 <534CED5B.2090100@hitachi.com>
From: Zhan Jianyu <nasa4836@gmail.com>
Date: Tue, 15 Apr 2014 16:33:03 +0800
Message-ID: <CAHz2CGUBzeLQhe3CqgV_3+SFQmatFx1orsDBin68_c_oiaFTUg@mail.gmail.com>
Subject: Re: [PATCH] kprobes: be more permissive when user specifies both
 symbol name and address
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
        David Miller <davem@davemloft.net>, rdunlap@infradead.org,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 4:27 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
>
>   Plus, if the p->offset and offs are different, fail too.

Oh, yeah, I have did this check it patch too.  BTW, I found that the
offset has different types
in kallsyms_lookup(which is unsigned long) and  in struct kprobe(which
is unsigned int)



Regards,
Jianyu Zhan
