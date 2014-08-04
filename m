Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaHDOts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:49:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaHDOtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:49:47 -0400
Date: Mon, 4 Aug 2014 16:47:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct
	pt_regs"
Message-ID: <20140804144735.GA22438@redhat.com>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com> <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <CALCETrWA6SL52SOM3yifvc0Pjz-HTOvs8G8fXo9TqF5v=0eTzw@mail.gmail.com> <CAK1hOcOwD0cpVWZEV8FP40y9149feUdaxoszQC+wWQfAwU4MNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcOwD0cpVWZEV8FP40y9149feUdaxoszQC+wWQfAwU4MNQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Denys Vlasenko wrote:
>
> "why do we need percpu old_rsp thingy?" in particular.

See thread_struct->usersp, current_user_stack_pointer().

Oleg.

