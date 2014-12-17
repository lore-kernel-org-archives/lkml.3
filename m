Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbaLQPXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:23:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaLQPXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:23:24 -0500
Date: Wed, 17 Dec 2014 16:23:56 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 3/3] samples: add sample live patching module
Message-ID: <20141217152356.GC1270@pathway.suse.cz>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
 <1418752700-14649-4-git-send-email-sjenning@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418752700-14649-4-git-send-email-sjenning@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-12-16 11:58:20, Seth Jennings wrote:
> Add a sample live patching module.
> 
> Signed-off-by: Seth Jennings <sjenning@redhat.com>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
