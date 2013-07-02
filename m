Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab3GBIBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:01:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:10742 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3GBIBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:01:07 -0400
X-Spam-Score: -100.7
Message-ID: <51D2888E.8020503@asianux.com>
Date: Tue, 02 Jul 2013 16:00:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Richard Weinberger <richard@nod.at>, Arnd Bergmann <arnd@arndb.de>,
        Jeff Dike <jdike@addtoit.com>, David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
References: <51CA8AB8.7080504@asianux.com> <51CA900E.9020407@nod.at> <51CA9E92.4000107@asianux.com> <51CAA0C6.60007@nod.at> <51CAA78C.5040900@asianux.com> <51CAA8D6.9000505@nod.at> <51CAAD1D.8050801@asianux.com> <51CAAE7C.9090003@nod.at> <51CAB556.4070700@asianux.com> <51CAB689.70008@nod.at> <CAMuHMdXw6VYhnNWcVfWc9ssxKTqKFcDbN4WXL5i=eNGy+gXcRA@mail.gmail.com> <51CABBDD.403@asianux.com> <51CABFAC.1040505@nod.at> <51CAC0D0.60505@asianux.com> <51D0DE09.4090702@asianux.com> <51D0FAFE.5010500@asianux.com> <51D23766.8000605@asianux.com> <CAMuHMdUvctqqStGE0QKM_BqgK2f6f_E6T=przdYszZo9A_oDzg@mail.gmail.com>
In-Reply-To: <CAMuHMdUvctqqStGE0QKM_BqgK2f6f_E6T=przdYszZo9A_oDzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 03:19 PM, Geert Uytterhoeven wrote:
> On Tue, Jul 2, 2013 at 4:13 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> > 'asm-generic' need provide necessary configuration checking, if can't
>> > pass checking, 'asm-generic' shouldn't implement it.
>> >
>> > For 'COMPILE_TEST', according to its help contents, 'asm-generic' need
>> > let it pass configuration checking, and provide related dummy contents
>> > for it.
>> >
>> > Part of 'COMPLE_TEST' help contents in "init/Kconfig":
>> >
>> >   "...Despite they cannot be loaded there (or even when they load they cannot be used due to missing HW support)..."
>> >
>> >
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> NAKed-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Please don't clutter the code with checks for CONFIG_COMPILE_TEST.

Do you mean: 'asm-generic' should not support 'COMPILE_TEST' (the
platform should not support 'COMPILE_TEST") ?

Or you mean: 'COMPILE_TEST' should not exist in kernel ?

Can we use 'asm-default' instead of 'asm-generic', since "if HW support,
it will provide default value, or it will provide nothing" ?


Thanks.
-- 
Chen Gang
