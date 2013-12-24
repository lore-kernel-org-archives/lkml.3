Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab3LXBDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:03:38 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46857 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3LXBDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:03:36 -0500
Message-ID: <52B8DD5F.2060809@hitachi.com>
Date: Tue, 24 Dec 2013 10:03:27 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Subject: Re: Re: [PATCH -tip  2/3] perf-probe: Support dwarf on uprobe
 events
References: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal> <20131220100259.7169.57512.stgit@kbuild-fedora.novalocal> <20131220180154.GB28878@ghostprotocols.net> <52B75C04.6000404@hitachi.com> <20131223143428.GG28878@ghostprotocols.net>
In-Reply-To: <20131223143428.GG28878@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/23 23:34), Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 23, 2013 at 06:39:16AM +0900, Masami Hiramatsu escreveu:
>> (2013/12/21 3:01), Arnaldo Carvalho de Melo wrote:
>>> Em Fri, Dec 20, 2013 at 10:02:59AM +0000, Masami Hiramatsu escreveu:
>>>> Support dwarf(debuginfo) based operations for uprobe events.
>>>> With this change, perf probe can analyze debuginfo of user
>>>> application binary to set up new uprobe event.
>>>> This allows perf-probe --add/--line works with -x option.
>>>> (Actually, --vars has already accepted -x option)
>>>
>>> Can you provide an example?
>>>
>>
>> OK, here is the examples from 0/3. :)
> 
> Pleasn readnthis message:
> 
> http://lkml.kernel.org/r/20131218141125.GT21999@twins.programming.kicks-ass.net
> 
> It is unrelated to this code being discussed in this thread, but
> provides another request for having better patch descriptions and to
> have relevant discussion in the corresponding patch, not just on "0/N".

OK, I'll take care of it.

> 
>> Or, should I better put this into the patch description too?
> 
> Sure thing, please!

I see, I'll update it with the examples in the next version.

> 
>> For example)
>> - Shows the probe-able lines of the given function
> 
> The above line would be more clear as:
> 
> "The following command shows the probe-able lines of a given user space
>  function, something that so far was only available in the 'perf probe'
>  tool for kernel space functions:"

Thanks! :)


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


