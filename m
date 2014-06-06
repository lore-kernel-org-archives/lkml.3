Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaFFVdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:33:51 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:48076 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaFFVdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:33:50 -0400
MIME-Version: 1.0
In-Reply-To: <539231B8.8000400@zytor.com>
References: <201406042235.s54MZgwP020553@terminus.zytor.com>
 <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>
 <CA+55aFyKTbBUM4DJukmW5fiH213D0FbVmrreR9wOtMRmmijQ9Q@mail.gmail.com>
 <CALCETrWA92Q4ro9eaRkUrebjgQT7B2uj+bK81m9byZnDY_eMxA@mail.gmail.com>
 <CA+55aFx8ezbe-mCYWp6kM8Nh3oUQd_+SNz6mLoGQtMVDk3EALA@mail.gmail.com>
 <53922F74.20406@linux.intel.com> <CALCETrXpCMdyPjM6MSbxoi0matoYLfduuSiwmTjGCUU62KOsTw@mail.gmail.com>
 <539231B8.8000400@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 6 Jun 2014 14:33:28 -0700
Message-ID: <CALCETrXUDiN2RspG3hK4ovDU9WSfo8hnvQjx7cx=Au7A7N1v_w@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.16
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stefani Seibold <stefani@seibold.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 2:25 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/06/2014 02:22 PM, Andy Lutomirski wrote:
>>
>> Sounds good.
>>
>> In the mean time, a trivial fix is here:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=vdso/cleanup_fixes&id=cf780a0dc71f7cbd9a417e6ce2d5ddf56abccb74
>>
>> (or it will be once the mirrors sync)
>>
>
> Unfortunately gcc didn't introduce __BYTE_ORDER__ at the compiler level
> until 2010.  This makes it harder to do this in a portable manner.

Is there anything wrong with using __get_unaligned_leNN directly?

>
>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
