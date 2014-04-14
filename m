Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaDNMY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:24:57 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:37362 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaDNMY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:24:56 -0400
MIME-Version: 1.0
In-Reply-To: <534B6EA5.5090302@hitachi.com>
References: <20140406201628.GA507@redhat.com> <20140410141806.GA23997@redhat.com>
 <5346AB07.4090909@redhat.com> <201404101902.38639.vda.linux@googlemail.com> <534B6EA5.5090302@hitachi.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 14 Apr 2014 14:24:35 +0200
Message-ID: <CAK1hOcNM-kDF3QHWLJCAuVi0xM0Cf3OUixowyrEp_JN=L6yS2w@mail.gmail.com>
Subject: Re: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 7:14 AM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
>> You can check whether insn had any prefix by checking
>> insn->prefixes->nbytes != 0...
>
> No, since there are other prefixes (and it may be meaningless)
> you should find 0x66 in insn->prefixes->bytes[].

What "no"? Is my statement not true? Please reread it.
I'm not talking about checking for 0x66 prefix.
Here, I am talking about checking that insn has *any* prefix.
