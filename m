Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3KGRyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:54:14 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:33120 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3KGRyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:54:11 -0500
MIME-Version: 1.0
In-Reply-To: <20131107125532.GB3355@khazad-dum.debian.net>
References: <CALCETrUt7Ojh5Yy4KYgBPj_wBr=fzKKJ=OOgGP9BtXoKrr9QnA@mail.gmail.com>
	<CAGXu5jJreo001uBLV8oAgR_Z2WZK2qtH8YfvriQJVAQ4SgdRzw@mail.gmail.com>
	<20131106004058.GU16735@n2100.arm.linux.org.uk>
	<CALCETrXd7SknNCptTTojBzOo+RNzPwGrgjigVdVeOkGMAtajWg@mail.gmail.com>
	<20131107125532.GB3355@khazad-dum.debian.net>
Date: Thu, 7 Nov 2013 09:54:09 -0800
X-Google-Sender-Auth: 2p1kgysLkeGL9iwReBuY5cdWm-Y
Message-ID: <CAGXu5jK6Q_CZTvKo3xT9CEjJ5qyMAP2qHby1YPCg4b72aRUNBg@mail.gmail.com>
Subject: Re: ARM audit, seccomp, etc are broken wrt OABI syscalls
From: Kees Cook <keescook@chromium.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Moore <paul@paul-moore.com>, Richard Weinberger <richard@nod.at>,
        libseccomp-discuss@lists.sourceforge.net,
        Will Drewry <wad@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 4:55 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Tue, 05 Nov 2013, Andy Lutomirski wrote:
>> Maybe the thing to do is to put a warning in the config text for
>> CONFIG_OABI_COMPAT that describes the problems (malicious userspace
>> can confuse syscall auditors, strace, etc.), change the "if in doubt"
>> part to N, and disable seccomp filters if CONFIG_OABI_COMPAT.  That
>> might even get Debian to change their default.
>
> Bug reported to the Debian BTS: #728975
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=728975

FWIW, Ubuntu has also now disabled OABI_COMPAT going forward:
https://lists.ubuntu.com/archives/kernel-team/2013-November/034242.html

-Kees

-- 
Kees Cook
Chrome OS Security
