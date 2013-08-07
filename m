Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab3HGGB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:01:29 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47455 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab3HGGB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:01:28 -0400
Message-ID: <5201E2AC.2010604@hitachi.com>
Date: Wed, 07 Aug 2013 15:01:16 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip ] x86/insn: Add Haswell-introduced opcodes
References: <20130806073750.4049.12365.stgit@udc4-manage.rcp.hitachi.co.jp> <52011361.6060606@zytor.com> <5201D24F.8010403@hitachi.com> <5201D50C.3020602@zytor.com>
In-Reply-To: <5201D50C.3020602@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/07 14:03), H. Peter Anvin wrote:
> On 08/06/2013 09:51 PM, Masami Hiramatsu wrote:
>>
>> Thanks, Andi also asked me to support them ;)
>> As far as I can see, that requires more work to support
>> EVEX decoding. And perhaps, I have to classify new instructions
>> and operands and introduce new abbreviations/superscripts for
>> them, because there is no opcode map in the above document.
>>
>> Would you intel guys have any idea about new opcode map?
>>
> 
> What is it you need, specifically?

A new opcode map about AVX-512, which introduces ZMM registers which
has 512-bit width. Perhaps, we need to introduce new code of operand
type for that new large registers, I guess it is Octa-Quadword(oq)? :)
And also, MASK instructions may require new addressing method codes for
opmask registers. Of course I can make new one for those and update
after official opcode map is released, as I did on AVX instructions.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


