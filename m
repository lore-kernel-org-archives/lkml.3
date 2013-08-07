Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3HGFDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:03:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46278 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab3HGFDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:03:54 -0400
Message-ID: <5201D50C.3020602@zytor.com>
Date: Tue, 06 Aug 2013 22:03:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip ] x86/insn: Add Haswell-introduced opcodes
References: <20130806073750.4049.12365.stgit@udc4-manage.rcp.hitachi.co.jp> <52011361.6060606@zytor.com> <5201D24F.8010403@hitachi.com>
In-Reply-To: <5201D24F.8010403@hitachi.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 09:51 PM, Masami Hiramatsu wrote:
> 
> Thanks, Andi also asked me to support them ;)
> As far as I can see, that requires more work to support
> EVEX decoding. And perhaps, I have to classify new instructions
> and operands and introduce new abbreviations/superscripts for
> them, because there is no opcode map in the above document.
> 
> Would you intel guys have any idea about new opcode map?
> 

What is it you need, specifically?

	-hpa


