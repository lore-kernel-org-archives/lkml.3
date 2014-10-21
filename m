Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaJUML0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:11:26 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50628 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbaJUMLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:11:25 -0400
Message-ID: <54464D64.9090409@hitachi.com>
Date: Tue, 21 Oct 2014 21:11:16 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v3 1/2] kprobes: introduce weak arch_check_ftrace_location()
 helper function
References: <1413880229-4796-1-git-send-email-heiko.carstens@de.ibm.com> <1413880229-4796-2-git-send-email-heiko.carstens@de.ibm.com> <544627D0.60309@hitachi.com> <20141021120046.GC4161@osiris>
In-Reply-To: <20141021120046.GC4161@osiris>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/21 21:00), Heiko Carstens wrote:
> On Tue, Oct 21, 2014 at 06:30:56PM +0900, Masami Hiramatsu wrote:
>> (2014/10/21 17:30), Heiko Carstens wrote:
>>> Introduce weak arch_check_ftrace_location() helper function which
>>> architectures can override in order to implement handling of kprobes
>>> on function tracer call sites on their own, without depending on
>>> common code or implementing the KPROBES_ON_FTRACE feature.
>>>
>>> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
>>
>> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>
>> Thanks!
> 
> Ok, thanks!
> 
> If there are no objections, this patch and the s390 only patch will
> go upstream via the s390 tree. Is that ok?

Yeah, I think it's OK for me.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


