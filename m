Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab3DZPq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:46:29 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:44829 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab3DZPqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:46:25 -0400
Message-ID: <1366991182.8964.223.camel@edumazet-glaptop>
Subject: RE: [RFC PATCH net-next 2/6] x86: bpf_jit_comp: support
 BPF_S_ANC_SECCOMP_LD_W instruction
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Xi Wang <xi.wang@gmail.com>, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Eric Dumazet <edumazet@google.com>, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Apr 2013 08:46:22 -0700
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7209@saturn3.aculab.com>
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com>
	 <1366962706-24204-3-git-send-email-xi.wang@gmail.com>
	 <1366985926.8964.190.camel@edumazet-glaptop>
	 <CAKU6vyZfYR-2408G0_Fkp-PS5x5rMH+s4_OOWqqi7Nt+UfiUPg@mail.gmail.com>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7208@saturn3.aculab.com>
	 <1366990066.8964.216.camel@edumazet-glaptop>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7209@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 16:38 +0100, David Laight wrote:

> The call needs the displacement from the address of
> the instruction following the call.
> I can't imagine any way in which above can allow for the 5 byte
> 'mov imm32,%edi' instruction.
> 
> I'd have thought there would be an EMIT1_imm32().
> (I've written a lot of x86 asm in my days!)
> 

Thats the same. 

off32 is a 32bit quantity, or immediate 32 if you prefer.



