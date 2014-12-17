Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaLQDmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 22:42:12 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:57502 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaLQDmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 22:42:10 -0500
MIME-Version: 1.0
In-Reply-To: <20141216190542.GB15593@cerebellum.variantweb.net>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
	<CAKTCnzk6Kn=dngyY944k_DRyTV8dssYKhBThmdfGEm6vAPBPHg@mail.gmail.com>
	<20141216190542.GB15593@cerebellum.variantweb.net>
Date: Wed, 17 Dec 2014 09:12:09 +0530
Message-ID: <CAKTCnzkkxTDO_CST79YHuKQF_xOFAA4LCZjsRSO1bcM7B3qgBw@mail.gmail.com>
Subject: Re: [PATCHv7 0/3] Kernel Live Patching
From: Balbir Singh <bsingharora@gmail.com>
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 12:35 AM, Seth Jennings <sjenning@redhat.com> wrote:
> On Tue, Dec 16, 2014 at 11:45:12PM +0530, Balbir Singh wrote:
>> On Tue, Dec 16, 2014 at 11:28 PM, Seth Jennings <sjenning@redhat.com> wrote:
>> >
>> > Changelog:
>> >
>> > Thanks for all the feedback!
>> >
>>
>> Could you describe what this does to signing? I presume the patched
>> module should cause a taint on module signing?
>
> The patch module can be signed to avoid the taint of being unsigned,
> assuming you have the signing key for the kernel you are running.
> However we do taint with a new taint flag (see 1/3) to indicate
> that the kernel has been patched.
>

I see, so the assumption is that the module and patch would be signed
with the same key?

Thanks,
Balbir Singh.
