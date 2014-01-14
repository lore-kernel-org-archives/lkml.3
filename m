Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaANKBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:01:50 -0500
Received: from linux-libre.fsfla.org ([208.118.235.54]:57651 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaANKBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:01:46 -0500
From: Alexandre Oliva <oliva@gnu.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [3.13-rc regression] Unbreak Loongson2 and r4k-generic flush icache range
Organization: Free thinker, not speaking for the GNU Project
References: <ord2jwnmwd.fsf@livre.home> <52D3EA9B.6020404@cogentembedded.com>
Date: Tue, 14 Jan 2014 08:01:22 -0200
In-Reply-To: <52D3EA9B.6020404@cogentembedded.com> (Sergei Shtylyov's message
	of "Mon, 13 Jan 2014 17:31:07 +0400")
Message-ID: <oriotmopal.fsf@livre.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 13, 2014, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> wrote:

> Hello.

>> Commit 14bd8c08, that replaced Loongson2-specific ifdefs with cpu tests,
>> inverted the CPU test in local_r4k_flush_icache_range.  Loongson2 won't
>> boot up using the generic icache flush code.  Presumably other CPUs
>> might face other problems when presented with Loongson2-specific icache
>> flush code too.  This patch enabled my Yeeloong to boot up successfully
>> a 3.13-rc kernel for the first time, after a long git bisect session.

>> Signed-off-by: Alexandre Oliva <lxoliva@fsfla.org>

>    Fix for this issue has been posted long ago:

> http://marc.info/?l=linux-mips&m=138575576803890

Thanks.  As long ago as that was, I still don't see it in Torvalds's
master branch.  Was a pull request including this patch ever send his
way?  Such a trivial fix for such a show-stopper shouldn't find any
difficulties making 3.13, I think.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
