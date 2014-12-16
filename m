Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaLPTGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 14:06:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbaLPTGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 14:06:21 -0500
Date: Tue, 16 Dec 2014 13:05:42 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Balbir Singh <bsingharora@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv7 0/3] Kernel Live Patching
Message-ID: <20141216190542.GB15593@cerebellum.variantweb.net>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
 <CAKTCnzk6Kn=dngyY944k_DRyTV8dssYKhBThmdfGEm6vAPBPHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKTCnzk6Kn=dngyY944k_DRyTV8dssYKhBThmdfGEm6vAPBPHg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 11:45:12PM +0530, Balbir Singh wrote:
> On Tue, Dec 16, 2014 at 11:28 PM, Seth Jennings <sjenning@redhat.com> wrote:
> >
> > Changelog:
> >
> > Thanks for all the feedback!
> >
> 
> Could you describe what this does to signing? I presume the patched
> module should cause a taint on module signing?

The patch module can be signed to avoid the taint of being unsigned,
assuming you have the signing key for the kernel you are running.
However we do taint with a new taint flag (see 1/3) to indicate
that the kernel has been patched.

Seth

> 
> Balbir Singh
