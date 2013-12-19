Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3LSJh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:37:29 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:56192 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3LSJh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:37:26 -0500
MIME-Version: 1.0
In-Reply-To: <20131219090409.14309.25677.stgit@kbuild-fedora.novalocal>
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
	<20131219090409.14309.25677.stgit@kbuild-fedora.novalocal>
Date: Thu, 19 Dec 2013 17:37:25 +0800
Message-ID: <CAGdX0WFKYHqXrVQ6LBw0YgH_H6cP=LZVCBe1iOvEXsHQPD8Zmg@mail.gmail.com>
Subject: Re: [PATCH -tip v6 06/22] [BUGFIX] x86: Prohibit probing on memcpy/memset
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Thu, Dec 19, 2013 at 5:04 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> memcpy/memset functions are fundamental functions and
> those are involved in kprobe's exception handling.
> Prohibit probing on them to avoid kernel crash.
>
Would you please let me know the LKML link of that bugfix, I cannot
find it in my LKML fold.

No objection on this patch. :) just want to know more, It seems there
have no problem to probe memcpy in my box, maybe I didn't hit the
crash code path.

Thanks.

Jovi
