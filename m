Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaLQGqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 01:46:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaLQGqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 01:46:14 -0500
Date: Wed, 17 Dec 2014 07:46:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Balbir Singh <bsingharora@gmail.com>
cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv7 0/3] Kernel Live Patching
In-Reply-To: <CAKTCnz=F=r5PQejgk6yZKYzvmkFAj7TZwax1rHxnAcLVFZ0_Gg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1412170744560.1680@pobox.suse.cz>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com> <CAKTCnzk6Kn=dngyY944k_DRyTV8dssYKhBThmdfGEm6vAPBPHg@mail.gmail.com> <alpine.LNX.2.00.1412162111320.1680@pobox.suse.cz> <CAKTCnz=F=r5PQejgk6yZKYzvmkFAj7TZwax1rHxnAcLVFZ0_Gg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Balbir Singh wrote:

> >> Could you describe what this does to signing? I presume the patched
> >> module should cause a taint on module signing?
> >
> > Hmm, why should it?
> 
> I wanted to clarify it from a different perspective
> 
> If the base image is signed by X and the patched module is signed by
> Y, is that supported. What does it imply in the case of live-patching?

Why should that matter? Both are signed by keys that kernel is configured 
to trust, which makes them equal (even though they are technically 
different).

-- 
Jiri Kosina
SUSE Labs
