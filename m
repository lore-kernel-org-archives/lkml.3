Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbbAUNlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:41:19 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:59243 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbbAUNlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:41:10 -0500
MIME-Version: 1.0
In-Reply-To: <1421581520-2816-2-git-send-email-heukelum@fastmail.fm>
References: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm> <1421581520-2816-2-git-send-email-heukelum@fastmail.fm>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 21 Jan 2015 14:40:39 +0100
Message-ID: <CAK1hOcMqp8pHVLRPfH9ui1UFvnU1M2bUpdkecdGW-cmSHth9_Q@mail.gmail.com>
Subject: Re: [PATCHv2 1/4] x86_64: cleanup THREAD_INFO(reg,offset) macro
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@suse.de>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 12:45 PM, Alexander van Heukelum
<heukelum@fastmail.fm> wrote:
> The macro THREAD_INFO(reg,offset) is used in assembly to compute the
> offset between the user ptregs and the thread_info struct. Change
> the macro and all its uses so that offset is given as the current
> top of stack in the pt_regs frame. The generated code is identical.

What is the purpose of doing this?

I don't mean to say that it's pointless, but it is also not obvious
why it's better than the code before patch.
