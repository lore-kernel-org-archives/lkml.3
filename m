Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaLQMlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 07:41:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaLQMlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 07:41:01 -0500
Date: Wed, 17 Dec 2014 13:40:58 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Balbir Singh <bsingharora@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv7 0/3] Kernel Live Patching
Message-ID: <20141217124058.GC2433@suse.cz>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
 <CAKTCnzk6Kn=dngyY944k_DRyTV8dssYKhBThmdfGEm6vAPBPHg@mail.gmail.com>
 <alpine.LNX.2.00.1412162111320.1680@pobox.suse.cz>
 <CAKTCnz=F=r5PQejgk6yZKYzvmkFAj7TZwax1rHxnAcLVFZ0_Gg@mail.gmail.com>
 <alpine.LNX.2.00.1412170744560.1680@pobox.suse.cz>
 <CAKTCnz=tA9LyGpOvM9LyBp+oBDTsW6t+=2C80On+-ysfRBpDqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKTCnz=tA9LyGpOvM9LyBp+oBDTsW6t+=2C80On+-ysfRBpDqg@mail.gmail.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 01:22:21PM +0530, Balbir Singh wrote:
> On Wed, Dec 17, 2014 at 12:16 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> > On Wed, 17 Dec 2014, Balbir Singh wrote:
> >
> >> >> Could you describe what this does to signing? I presume the patched
> >> >> module should cause a taint on module signing?
> >> >
> >> > Hmm, why should it?
> >>
> >> I wanted to clarify it from a different perspective
> >>
> >> If the base image is signed by X and the patched module is signed by
> >> Y, is that supported. What does it imply in the case of live-patching?
> >
> > Why should that matter? Both are signed by keys that kernel is configured
> > to trust, which makes them equal (even though they are technically
> > different).
> >
> 
> I am not sure they are equal, others can comment

Since any loaded kernel module can do virtually anything on a machine,
there can only be one level of trust. As such, all trusted keys are
equally trusted.

-- 
Vojtech Pavlik
Director SUSE Labs
