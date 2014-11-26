Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaKZJBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:01:05 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42032 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaKZJBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:01:03 -0500
Message-ID: <547596C6.2050303@hitachi.com>
Date: Wed, 26 Nov 2014 18:00:54 +0900
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
Subject: Re: [PATCHv4 0/3] Kernel Live Patching
References: <1416935709-404-1-git-send-email-sjenning@redhat.com>
In-Reply-To: <1416935709-404-1-git-send-email-sjenning@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/26 2:15), Seth Jennings wrote:
> Note to Steve:
> Masami's IPMODIFY patch is heading for -next via your tree.  Once it arrives,
> I'll rebase and make the change to set IPMODIFY.  Do not pull this for -next
> yet.  This version (v4) is for review and gathering acks.

BTW, as we discussed IPMODIFY is an exclusive flag. So if we allocate ftrace_ops
for each function in each patch, it could be conflict each other.
Maybe we need to have another ops hashtable to find such conflict and new
handler to handle it.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


