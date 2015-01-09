Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbbAINCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:02:23 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:33704 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbbAINCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:02:22 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <54AD3692.7040903@supelec.fr>
References: <54AD2C56.10700@gmail.com> <54AD3692.7040903@supelec.fr>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 9 Jan 2015 14:02:01 +0100
Message-ID: <CAKgNAkjzoJ8REzE8HQUZwrHjZaW+AqDB+4PTtBWH-K2atUipzA@mail.gmail.com>
Subject: Re: Request for review of adjtimex(2) man page
To: Laurent Georget <laurent.georget@supelec.fr>
Cc: lkml <linux-kernel@vger.kernel.org>, Petr Gajdos <PGajdos@suse.cz>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Jeff Epler <jepler@unpythonic.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On 7 January 2015 at 14:37, Laurent Georget <laurent.georget@supelec.fr> wrote:
> Hello,
>
>
>>I've added a large number
>> of FIXMEs in the draft below, and would be happy if anyone can supply
>> some content to fill any of the gaps.
>
> Isn't the man page going to be very long and hard to read if we explain all
> the NTP internals in adjtimex.2?

That's not my intention. But in various places it would be useful for
the reader to know where they can go for further information.

> I think we could create a second man page
> (for instance ntp.7) in section 7 to provide extensive explanations and refer
> to it from adjtimex.2. Does that seem okay?

Maybe. But I'm not sure that it's needed. See above.

>> .BR STA_PLL
>> Enable phase-locked loop (PLL) updates (read-write) via
>> .\" FIXME Any pointer to further information about what this means?
>> .\"       (It was not immediately obvious from a scan of the RFC, whether
>> .\"       this is described in the RFC.)
>> .BR ADJ_OFFSET .
>
>> .BR STA_FLL
>> Select frequency-locked loop (FLL) mode (read-write).
>> .\" FIXME Any pointer to further information about what this means?
>> .\"       (It was not immediately obvious from a scan of the RFC, whether
>> .\"       this is described in the RFC.)
>
> In this particular case, for example, PLL and FLL are the two modes by which
> the clock offset can be controlled. Roughly speaking, PLL is phase locking
> (the clock time is adjusted to the source time) and FLL is frequency locking
> (the clock frequency is adjusted to the source frequency). Is that level of
> details be sufficient for adjtimex.2?
>
> Valuable resources that go beyond the content of the RFC are publications and
> presentations from Pr. David Mills (http://www.eecis.udel.edu/~mills/) like
> http://www.eecis.udel.edu/~mills/database/brief/clock/clock.pdf.

Thanks for the pointers.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
