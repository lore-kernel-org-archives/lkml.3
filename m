Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965941AbaGRRRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:17:31 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:42344 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965798AbaGRRR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:17:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1407181325200.15709@namei.org>
References: <1405620518-18495-1-git-send-email-keescook@chromium.org> <alpine.LRH.2.11.1407181325200.15709@namei.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 18 Jul 2014 10:17:06 -0700
Message-ID: <CALCETrUv3G+C3PTOD1FJGOG8AQCA30hNkUiusCnQDGq6Kt_Feg@mail.gmail.com>
Subject: Re: [PATCH v12 11/11] seccomp: add thread sync ability
To: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, David Drysdale <drysdale@google.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 8:26 PM, James Morris <jmorris@namei.org> wrote:
> On Thu, 17 Jul 2014, Kees Cook wrote:
>
>> Twelfth time's the charm! :)
>
> Btw, there doesn't seem to be an official seccomp maintainer.  Kees, would
> you like to volunteer for this?  If so, send in a patch for MAINTAINERS,
> and set up a git tree for me to pull from.

*snicker* :)

Kees, if you take on this awesome responsibility, should I send you a
rebased version of the fastpath stuff?  If so, I think that the
arch-neutral part should go in through your shiny new tree (once it's
reviewed to your satisfaction), and I'll ask hpa to pick up the x86
part.

I'd volunteer to be a "R:eviewer", but I don't think that the R tag
has made it into MAINTAINERS yet.

--Andy
