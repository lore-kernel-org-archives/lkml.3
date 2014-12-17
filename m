Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaLQDna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 22:43:30 -0500
Received: from mail-yk0-f171.google.com ([209.85.160.171]:57673 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLQDn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 22:43:29 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1412162111320.1680@pobox.suse.cz>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
	<CAKTCnzk6Kn=dngyY944k_DRyTV8dssYKhBThmdfGEm6vAPBPHg@mail.gmail.com>
	<alpine.LNX.2.00.1412162111320.1680@pobox.suse.cz>
Date: Wed, 17 Dec 2014 09:13:28 +0530
Message-ID: <CAKTCnz=F=r5PQejgk6yZKYzvmkFAj7TZwax1rHxnAcLVFZ0_Gg@mail.gmail.com>
Subject: Re: [PATCHv7 0/3] Kernel Live Patching
From: Balbir Singh <bsingharora@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
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

On Wed, Dec 17, 2014 at 1:44 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 16 Dec 2014, Balbir Singh wrote:
>
>> Could you describe what this does to signing? I presume the patched
>> module should cause a taint on module signing?
>
> Hmm, why should it?
>

I wanted to clarify it from a different perspective

If the base image is signed by X and the patched module is signed by
Y, is that supported. What does it imply in the case of live-patching?

Balbir Singh
