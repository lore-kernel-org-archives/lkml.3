Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaLSDgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 22:36:12 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39803 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaLSDgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 22:36:10 -0500
Message-ID: <54939D22.7020204@hitachi.com>
Date: Fri, 19 Dec 2014 12:36:02 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCHv7 1/3] kernel: add TAINT_LIVEPATCH
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com> <1418752700-14649-2-git-send-email-sjenning@redhat.com> <5492BE01.7040705@hitachi.com> <alpine.LNX.2.00.1412181651260.1680@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1412181651260.1680@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/19 0:52), Jiri Kosina wrote:
> On Thu, 18 Dec 2014, Masami Hiramatsu wrote:
> 
>>> This adds a new taint flag to indicate when the kernel or a kernel
>>> module has been live patched.  This will provide a clean indication in
>>> bug reports that live patching was used.
>>>
>>> Additionally, if the crash occurs in a live patched function, the live
>>> patch module will appear beside the patched function in the backtrace.
>>>
>>> Signed-off-by: Seth Jennings <sjenning@redhat.com>
>>
>> Looks good to me.
>>
>> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Masami, just for completness -- is this just for 1/3, or for the whole 
> series? (so that I get it right once I am applying the patches to git 
> tree).

Yeah, Now all the patches in this series are OK to me :)

Feel free to add my Reviewed-by.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

for this series :)

Thank you!



> 
> Thanks,
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


