Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab3K0WcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:32:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53366 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab3K0WcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:32:05 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131127222944.GB748@pd.tnic>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <5294F10C.8060901@amacapital.net> <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com> <52964EC7.9000504@zytor.com> <52966C0A.7070201@zytor.com> <20131127222104.GA748@pd.tnic> <b6331d08-d5fb-4ec5-80e2-ff32d3ce93ce@email.android.com> <20131127222944.GB748@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Add a text_poke syscall v2
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 27 Nov 2013 14:31:11 -0800
To: Borislav Petkov <bp@alien8.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <cb0c1623-0e58-4418-b22e-cdcadbf31dea@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, we're not... sysexit/sysret doesn't count.

Borislav Petkov <bp@alien8.de> wrote:
>On Wed, Nov 27, 2013 at 02:25:29PM -0800, H. Peter Anvin wrote:
>> Actually the CPUID is superfluous on anything than the executing CPU
>> since IRET is serializing.
>
>Why not on the executing core too? We're IRET-ting there too.
>
>Which would mean that a dummy empty syscall would be enough too since
>we
>need the serialization only.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
