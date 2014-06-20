Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbaFTCOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 22:14:54 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35508 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbaFTCOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 22:14:53 -0400
Message-ID: <53A39915.6060807@hitachi.com>
Date: Fri, 20 Jun 2014 11:14:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: Re: [PATCH -tip v2 1/3] ftrace: Simplify ftrace_hash_disable/enable
 path in ftrace_hash_move
References: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal> <20140617110442.15167.81076.stgit@kbuild-fedora.novalocal> <20140619220800.5d4b790c@gandalf.local.home>
In-Reply-To: <20140619220800.5d4b790c@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/20 11:08), Steven Rostedt wrote:
> On Tue, 17 Jun 2014 11:04:42 +0000
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Simplify ftrace_hash_disable/enable path in ftrace_hash_move
>> for hardening the process if the memory allocation failed.
>>
> 
> Regardless of what we do with IPMODIFY, I pulled this into my 3.17
> queue. You don't need to resend it with any new versions of the patches.

OK, thanks Steve!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


