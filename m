Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaDNOGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:06:15 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:44500 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbaDNOGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:06:09 -0400
Message-ID: <534BEB47.9030606@hitachi.com>
Date: Mon, 14 Apr 2014 23:05:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
References: <20140406201628.GA507@redhat.com> <20140410141806.GA23997@redhat.com> <5346AB07.4090909@redhat.com> <201404101902.38639.vda.linux@googlemail.com> <534B6EA5.5090302@hitachi.com> <CAK1hOcNM-kDF3QHWLJCAuVi0xM0Cf3OUixowyrEp_JN=L6yS2w@mail.gmail.com>
In-Reply-To: <CAK1hOcNM-kDF3QHWLJCAuVi0xM0Cf3OUixowyrEp_JN=L6yS2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/14 21:24), Denys Vlasenko wrote:
> On Mon, Apr 14, 2014 at 7:14 AM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>>> You can check whether insn had any prefix by checking
>>> insn->prefixes->nbytes != 0...
>>
>> No, since there are other prefixes (and it may be meaningless)
>> you should find 0x66 in insn->prefixes->bytes[].
> 
> What "no"? Is my statement not true? Please reread it.
> I'm not talking about checking for 0x66 prefix.
> Here, I am talking about checking that insn has *any* prefix.

Ah, I see now, sorry. That's OK for me.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


