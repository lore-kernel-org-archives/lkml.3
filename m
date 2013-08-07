Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3HGEvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 00:51:37 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:34414 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3HGEvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 00:51:36 -0400
Message-ID: <5201D24F.8010403@hitachi.com>
Date: Wed, 07 Aug 2013 13:51:27 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH -tip ] x86/insn: Add Haswell-introduced opcodes
References: <20130806073750.4049.12365.stgit@udc4-manage.rcp.hitachi.co.jp> <52011361.6060606@zytor.com>
In-Reply-To: <52011361.6060606@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/07 0:16), H. Peter Anvin wrote:
> On 08/06/2013 12:37 AM, Masami Hiramatsu wrote:
>> Add TSX-NI related instructions and new instructions to
>> x86-opcode-map.txt according to the Intel(R) 64 and IA-32
>> Architectures Software Developer's Manual Vol2C (June, 2013).
>> This also includes below updates.
>>  - Fix a typo of MWAIT (the lack of (11B)).
>>  - Change NOP Ev to prefetchw Ev
>>  - Add CRC32 new prefix style (66&F2)
>>  - Add ADCX, ADOX, RDSEED, CLAC and STAC instructions
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
> 
> Thanks, applied!
> 
> You may want to also look at:
> 
> http://software.intel.com/en-us/intel-isa-extensions
> 
> ... specifically ...
> 
> http://software.intel.com/sites/default/files/319433-015.pdf
> 
> For a *lot* of new instructions coming down the pipe.

Thanks, Andi also asked me to support them ;)
As far as I can see, that requires more work to support
EVEX decoding. And perhaps, I have to classify new instructions
and operands and introduce new abbreviations/superscripts for
them, because there is no opcode map in the above document.

Would you intel guys have any idea about new opcode map?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


