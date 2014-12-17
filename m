Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaLQRPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:15:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbaLQRPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:15:05 -0500
Date: Wed, 17 Dec 2014 10:21:47 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Seth Jennings <sjenning@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 0/3] Kernel Live Patching
Message-ID: <20141217162147.GA9962@treble.redhat.com>
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 11:58:17AM -0600, Seth Jennings wrote:
> Changelog:
> 
> Thanks for all the feedback!
> 
> I think that we have something that is workable for everyone now.  Barring
> functional defects, I think we should put a hold on any nits to avoid churn for
> the moment and start gathering acks so that we are in a position to go into
> -next when the 3.19 window closes.
> 
> Also, I don't think patches 1/3 and 3/3 have changed since v5, so if you reviewed
> them then, they haven't changed.

For the set:

Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
