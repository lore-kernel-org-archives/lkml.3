Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3GKCV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:21:59 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37848 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab3GKCV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:21:57 -0400
Message-ID: <51DE16C1.4030403@hitachi.com>
Date: Thu, 11 Jul 2013 11:21:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/2] x86: make jump labels use int3-based breakpoint
 instead of stop_machine()
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/11 5:25), Jiri Kosina wrote:
> Hi,
> 
> this is a resurrection of a few years old idea to have jump labels use 
> synchronization based on int3 breakpoint rather than relying on 
> stop_machine() with all the consequences.
> 
> ftrace has been doing exactly this kind of patching for year since 
> 08d636b6 ("ftrace/x86: Have arch x86_64 use breakpoints instead of stop 
> machine").
> 
> This patchset first introduces generic text_poke_bp() that provides means 
> to perform this method of patching in parallel to text_poke_smp(), and 
> then converts x86 jump label code to use it.
> 
> If this is merged, I'll do a followup patch converting ftrace to use this 
> infrastructure as well, as it's doing the same thing in principle already.

Hi Jiri,

Thank you for taking over it! :)
If yours is merged, I can move optprobe on that too ;)

Thank you again!!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


