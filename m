Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3CBQWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 11:22:19 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:60167 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3CBQWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 11:22:17 -0500
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <20130303024851.4be2d2435da42a6010c6c8f8@canb.auug.org.au>
References: <5130DD94.2060408@imgtec.com>
	<CA+55aFw9qvUdrtEk_83-gEjZMTceONk=AuVsHuTtqOj=jpVPQg@mail.gmail.com>
	<5130F978.9040604@imgtec.com>
	<5131D2F0.2010705@imgtec.com>
	<20130303024851.4be2d2435da42a6010c6c8f8@canb.auug.org.au>
Date: Sat, 2 Mar 2013 16:22:15 +0000
X-Google-Sender-Auth: 3PdpkaWSfUfzC10ZXV21-e_2kEs
Message-ID: <CAAG0J9_dB0t-pnTW8in8=FpZw__HJF9Auhee4WJ3diOxy1DDrQ@mail.gmail.com>
Subject: Re: [GIT PULL] late arch/metag fixes for v3.9-rc1
From: James Hogan <james.hogan@imgtec.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Arnd <arnd@arndb.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 2 March 2013 15:48, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Sat, 2 Mar 2013 10:22:40 +0000 James Hogan <james.hogan@imgtec.com> wrote:
>>
>> Okay, I've rebased the arch/metag tree onto mainline to make all the
>> back-merges unnecessary and applied those simple fixes into "Build
>> infrastructure" and "Various other headers" commits (additionally
>> trivially removing ARCH_NO_VIRT_TO_BUS which is also now unnecessary).
>
> Pleas make sure that what you are submitting to Linus is the same as what
> you have in linux-next (i.e. reset your for-next branch as well).

Yes, for-next now moved to the rebased version.

Thanks
James
