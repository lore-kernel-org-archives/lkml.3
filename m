Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbaD3FKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:10:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45635 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbaD3FKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 01:10:40 -0400
Message-ID: <536085B7.5070002@zytor.com>
Date: Tue, 29 Apr 2014 22:10:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Pinski <pinskia@gmail.com>
CC: Hui Zhu <teawater@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, eparis@redhat.com,
        Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gdb@sourceware.org" <gdb@sourceware.org>
Subject: Re: [PATCH] Fix get ERESTARTSYS with m32 in x86_64 when debug by
 GDB
References: <CANFwon0oLO+qCtpewc=BxKBOm05aBMpV=yG0CxwW1isWHfnZqw@mail.gmail.com>	<53554846.3070608@zytor.com>	<CANFwon3zA9FMujmnN3nMiv8Zr8bU9o72XXa26dkePNq57U=JcQ@mail.gmail.com>	<53608125.2020103@zytor.com> <CA+=Sn1=y-smZOaD_yRxEwgu-PPaZYdQtB_RGPCA5-9wmB6=hvQ@mail.gmail.com>
In-Reply-To: <CA+=Sn1=y-smZOaD_yRxEwgu-PPaZYdQtB_RGPCA5-9wmB6=hvQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 10:08 PM, Andrew Pinski wrote:
> 
> restoring the values is hard since even the ptrace interface does not
> allow for that.
> 

So that begs the ultimate question, which is: given the fact that there
is *state missing* from the state vector (this is the core of the
problem), is there a way we can add that state so that gdb will be able
to save and restore it?

	-hpa


