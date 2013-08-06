Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab3HFPRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:17:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39694 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab3HFPRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:17:47 -0400
Message-ID: <52011361.6060606@zytor.com>
Date: Tue, 06 Aug 2013 08:16:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip ] x86/insn: Add Haswell-introduced opcodes
References: <20130806073750.4049.12365.stgit@udc4-manage.rcp.hitachi.co.jp>
In-Reply-To: <20130806073750.4049.12365.stgit@udc4-manage.rcp.hitachi.co.jp>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 12:37 AM, Masami Hiramatsu wrote:
> Add TSX-NI related instructions and new instructions to
> x86-opcode-map.txt according to the Intel(R) 64 and IA-32
> Architectures Software Developer's Manual Vol2C (June, 2013).
> This also includes below updates.
>  - Fix a typo of MWAIT (the lack of (11B)).
>  - Change NOP Ev to prefetchw Ev
>  - Add CRC32 new prefix style (66&F2)
>  - Add ADCX, ADOX, RDSEED, CLAC and STAC instructions
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>

Thanks, applied!

You may want to also look at:

http://software.intel.com/en-us/intel-isa-extensions

... specifically ...

http://software.intel.com/sites/default/files/319433-015.pdf

For a *lot* of new instructions coming down the pipe.

	-hpa

