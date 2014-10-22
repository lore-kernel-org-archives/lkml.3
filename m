Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbaJVUOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:14:03 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:38301 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbaJVUOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <87wq7sgfah.fsf@x220.int.ebiederm.org>
References: <1413978269-17274-1-git-send-email-drysdale@google.com>
 <1413978269-17274-4-git-send-email-drysdale@google.com> <87wq7sgfah.fsf@x220.int.ebiederm.org>
From: David Drysdale <drysdale@google.com>
Date: Wed, 22 Oct 2014 21:13:39 +0100
Message-ID: <CAHse=S951SJsyEf7KX38Q1OfaRUwcZ_f9NMkB8nPfQ1CSZzfuQ@mail.gmail.com>
Subject: Re: [PATCHv5 man-pages 3/3] execveat.2: initial man page for execveat(2)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 6:55 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> David Drysdale <drysdale@google.com> writes:
>> +.TH EXECVEAT 2 2014-04-02 "Linux" "Linux Programmer's Manual"
>> +.SH NAME
>> +execveat \- execute program relative to a directory file descriptor
>> +.SH SYNOPSIS
>> +.B #include <unistd.h>
>> +.sp
>> +.BI "int execve(int " fd ", const char *" pathname ","
>             ^^^^^^ That needs to be execveat

Ah yes, so it does -- thanks for spotting.
