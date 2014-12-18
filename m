Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaLRLzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:55:31 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58634 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaLRLza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:55:30 -0500
Message-ID: <5492C0A9.3080303@hitachi.com>
Date: Thu, 18 Dec 2014 20:55:21 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 0/3] Kernel Live Patching
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
In-Reply-To: <1418752700-14649-1-git-send-email-sjenning@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/17 2:58), Seth Jennings wrote:
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
> 
> changes in v7:
> - TODO: set IPMODIFY (not a blocker to moving forward)

Why don't you set this?
IPMODIFY series are not completely applied yet, but you can already
use the flag. All you need is just set it :)

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


