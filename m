Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaLPSPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:15:15 -0500
Received: from mail-yk0-f178.google.com ([209.85.160.178]:45580 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaLPSPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:15:13 -0500
MIME-Version: 1.0
In-Reply-To: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
Date: Tue, 16 Dec 2014 23:45:12 +0530
Message-ID: <CAKTCnzk6Kn=dngyY944k_DRyTV8dssYKhBThmdfGEm6vAPBPHg@mail.gmail.com>
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

On Tue, Dec 16, 2014 at 11:28 PM, Seth Jennings <sjenning@redhat.com> wrote:
>
> Changelog:
>
> Thanks for all the feedback!
>

Could you describe what this does to signing? I presume the patched
module should cause a taint on module signing?

Balbir Singh
