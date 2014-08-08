Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbaHHWtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:49:00 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:34536 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaHHWs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 18:48:57 -0400
MIME-Version: 1.0
In-Reply-To: <1407519880-6719-17-git-send-email-dvlasenk@redhat.com>
References: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com> <1407519880-6719-17-git-send-email-dvlasenk@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 9 Aug 2014 07:48:35 +0900
Message-ID: <CALCETrW-DQWgiJM1gOaxmacNmxbsDHHsCEVKErXR_pmmQZC_4w@mail.gmail.com>
Subject: Re: [PATCH 16/17] x86: entry_64.S: trivial optimization for ENOSYS
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2014 at 2:44 AM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
> This code uses a slightly shorter insn.

See this for an alternative approach:

http://thread.gmane.org/gmane.linux.kernel.cross-arch/24167

--Andy
