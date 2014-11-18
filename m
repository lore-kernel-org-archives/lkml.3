Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbaKROnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:43:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024AbaKROnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:43:09 -0500
Date: Tue, 18 Nov 2014 08:42:05 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/3] Kernel Live Patching
Message-ID: <20141118144205.GB1944@cerebellum.variantweb.net>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com>
 <5469888E.3090501@hitachi.com>
 <20141117145450.GA2314@cerebellum.variantweb.net>
 <546B5675.4060902@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546B5675.4060902@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 03:23:49PM +0100, Jiri Slaby wrote:
> On 11/17/2014, 03:54 PM, Seth Jennings wrote:
> > On Mon, Nov 17, 2014 at 02:33:02PM +0900, Masami Hiramatsu wrote:
> >> Hmm, btw, "LP" and "LPC" remind me line-printer and LPC bus :(
> >> Can we use LKP (Live Kernel Patching) or KLP (Kernel Live Patching) instead ?
> > 
> > Jiri S also mentioned this so I guess it is a common sentiment :)  He
> > suggested "lip" but I think I like "klp" better?  Jiri S sound good?
> 
> Definitely, I like both lkp and klp.

Great.  I'll make the change.

Thanks,
Seth

> 
> -- 
> js
> suse labs
> --
> To unsubscribe from this list: send the line "unsubscribe live-patching" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
