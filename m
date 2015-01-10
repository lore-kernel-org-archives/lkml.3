Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbbAJH46 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 02:56:58 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:35164 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbbAJH4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 02:56:55 -0500
Message-ID: <54B0DB3D.8010300@gmail.com>
Date: Sat, 10 Jan 2015 08:56:45 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Drysdale <drysdale@google.com>
CC: mtk.manpages@gmail.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>,
        Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for execveat(2)
References: <1416830039-21952-1-git-send-email-drysdale@google.com> <1416830039-21952-6-git-send-email-drysdale@google.com> <54AFF813.7050604@gmail.com> <CAHse=S9kRj00eRbB+7DQd39Cso1O2LcmZpBVCbuUa9EwRQKv_w@mail.gmail.com>
In-Reply-To: <CAHse=S9kRj00eRbB+7DQd39Cso1O2LcmZpBVCbuUa9EwRQKv_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 07:02 PM, David Drysdale wrote:
> On Fri, Jan 9, 2015 at 3:47 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> On 11/24/2014 12:53 PM, David Drysdale wrote:
>>> Signed-off-by: David Drysdale <drysdale@google.com>
>>> ---
>>>  man2/execveat.2 | 153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 153 insertions(+)
>>>  create mode 100644 man2/execveat.2
>>
>> David,
>>
>> Thanks for the very nicely prepared man page. I've done
>> a few very light edits, and will release the version below
>> with the next man-pages release.
> 
> Many thanks, one error (of mine) in 2 places pointed out below.

Well, the first error was yours. The second error was mine,
when I replicated your info about AT_SYMLINK_NOFOLLOW
into the ERRORS without verifying it. (Sorry about that!)

Both cases fixed now.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
