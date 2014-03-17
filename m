Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbaCQThP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:37:15 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43931 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaCQThM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:37:12 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXt7bqQxymOC0ke+4Uaqv7nGOHqw3YhVHf4YKvJ4b8WpQ@mail.gmail.com>
References: <CALCETrWbjazg_kAY1uAB+cMTdaJqtyGrTwQWNFCSzZ56B0KEkw@mail.gmail.com>
 <15044.1394017702@warthog.procyon.org.uk> <531906C7.5030409@zytor.com> <CALCETrXt7bqQxymOC0ke+4Uaqv7nGOHqw3YhVHf4YKvJ4b8WpQ@mail.gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 17 Mar 2014 20:36:50 +0100
X-Google-Sender-Auth: sBrU21ES4U1UKirqdtYKs74r2uE
Message-ID: <CAHO5Pa22=TGDS8JvvskL2BZiwXU2qcyD0FvJ1GinXHF4JXwZsA@mail.gmail.com>
Subject: Re: Making a universal list of syscalls?
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        libseccomp-discuss@lists.sourceforge.net,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 12:40 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Mar 6, 2014 at 3:37 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 03/05/2014 03:08 AM, David Howells wrote:
>>> It would be really nice if we could do this in such a manner that we could
>>> build strace from it.
>>
>> strace, seccomp, klibc, ... we all need more or less the same stuff.
>
> strace also needs to know what the pointed-to type is for pointer
> arguments, whether pointers are input, output, or both, and what kind
> of flags / constants fit in which integer slot.
>
> --Andy


Late to the party, but... Obviously man-pages would be interested in
any results here, so if you CCed me on any future work/results that
would be great.

Thanks,

Michael
