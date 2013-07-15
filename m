Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3GOVK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:10:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56718 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3GOVK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:10:56 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307152212290.11918@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1307131317350.11918@ionos.tec.linutronix.de>
	<CA+55aFwJAV7DnMAyMm+Hdp3uYrgn+BRcBS4cLGf+KGQCdhKwbg@mail.gmail.com>
	<51E1F988.7010700@zytor.com>
	<alpine.DEB.2.02.1307152212290.11918@ionos.tec.linutronix.de>
Date: Mon, 15 Jul 2013 14:10:56 -0700
X-Google-Sender-Auth: a6QExSTIPeVgQ-WpotK6yr3v0PQ
Message-ID: <CAGXu5j+jyhTpZOYy2+sYWzwCE9zPigJYCf+sKdsqnuaJ1P7g9w@mail.gmail.com>
Subject: Re: [GIT pull] x86 updates for 3.11
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 1:45 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sat, 13 Jul 2013, H. Peter Anvin wrote:
>
>> Fail on me.  I got rushed and sloppy.  I really need to automate looking
>> for warnings pre-commit and not rely on Fengguang's robot.
>
> /me too. I took it for granted that this was tested by Ingos machinery
> w/o noticing that it went in just when Ingo left for a long
> weekend. So in my own rush to get out for the weekend I left out my
> usual smoke tests on that branch. Sorry about that.

I apologize; I was rushed as well. I've changed my build and test
procedures to more loudly present warnings.

-Kees

--
Kees Cook
Chrome OS Security
