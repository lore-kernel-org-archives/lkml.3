Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab3GVIER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:04:17 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43590 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3GVIEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:04:15 -0400
Message-ID: <51ECE77A.50504@hitachi.com>
Date: Mon, 22 Jul 2013 17:04:10 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        yrl.pp-manager.tt@hitachi.com, Borislav Petkov <bpetkov@suse.de>
Subject: Re: Re: [PATCH -tip 3/3] x86: Remove unused text_poke_smp and
 text_poke_smp_batch
References: <20130718114738.26675.85914.stgit@mhiramat-M0-7522> <20130718114753.26675.18714.stgit@mhiramat-M0-7522> <20130722074339.GA25976@gmail.com>
In-Reply-To: <20130722074339.GA25976@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/22 16:43), Ingo Molnar wrote:
> arch/x86/kernel/kprobes/opt.c: In function 'setup_optimize_kprobe':
> arch/x86/kernel/kprobes/opt.c:394:6: error: dereferencing pointer to incomplete type
> arch/x86/kernel/kprobes/opt.c:395:6: error: dereferencing pointer to incomplete type
> arch/x86/kernel/kprobes/opt.c:396:6: error: dereferencing pointer to incomplete type

Hmm, setup_optimized_kprobes is already removed by 2/3 (this is actually
a series of tightly coupled patches). Could you check your working tree?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


