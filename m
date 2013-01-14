Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab3ANWo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:44:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58839 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab3ANWoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:44:25 -0500
MIME-Version: 1.0
In-Reply-To: <50F46E77.4070500@zytor.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<50F46E77.4070500@zytor.com>
Date: Mon, 14 Jan 2013 14:44:24 -0800
X-Google-Sender-Auth: fd1bWybCYOPzgtgFBNIo53BFx9c
Message-ID: <CAE9FiQVajL=XE7q5KckN6JQZJi2gvbnB1EDadfW6MFW37OoKWQ@mail.gmail.com>
Subject: Re: [PATCH v7u1 00/31] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 12:45 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> This is getting extremely unwieldy and we need to get it broken up a bit.
>
> I would really like to get the boot protocol changes earlier in the
> series, because it has interactions with work other people are doing and
> may need additional surgery.  That is, the additions of flags and fields
> to make it possible for the kernel to indicate that > 4 GB booting is
> possible, not the actual implementation thereof.  This split between
> protocol changes and implementation will also be useful for bisection.

When will we actually change protocol version number in the code?

We need to refer that number in the protocol doc.

Yinghai
