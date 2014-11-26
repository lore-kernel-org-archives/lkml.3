Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaKZPzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:55:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaKZPzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:55:42 -0500
Date: Wed, 26 Nov 2014 09:55:08 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/3] Kernel Live Patching
Message-ID: <20141126155508.GC29079@treble.hsd1.ky.comcast.net>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com>
 <547596C6.2050303@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <547596C6.2050303@hitachi.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 06:00:54PM +0900, Masami Hiramatsu wrote:
> (2014/11/26 2:15), Seth Jennings wrote:
> > Note to Steve:
> > Masami's IPMODIFY patch is heading for -next via your tree.  Once it arrives,
> > I'll rebase and make the change to set IPMODIFY.  Do not pull this for -next
> > yet.  This version (v4) is for review and gathering acks.
> 
> BTW, as we discussed IPMODIFY is an exclusive flag. So if we allocate ftrace_ops
> for each function in each patch, it could be conflict each other.
> Maybe we need to have another ops hashtable to find such conflict and new
> handler to handle it.

I agree, but this is not a problem with the current patch set because it
doesn't yet support patching the same function multiple times :-)

-- 
Josh
