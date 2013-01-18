Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3ARVnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:43:07 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:41231 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3ARVnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:43:05 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 18 Jan 2013 22:43:03 +0100
Message-ID: <CA+icZUV+ewSfwdGv+XjzVMF+V5d1t3r6MWGvoBgf08CN=KpBgQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 18 [MODSIGN: KEYS:]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 5:37 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20130117:
>
> Undropped tree: samung
>
> The powerpc tree still had a build failure.
>
> The driver-core tree gained a build failure for which I applied a merge
> fix patch.
>
> The gpio-lw tree gained a build failure so I used the version from
> next-20130117.
>
> The samsung tree lost the majority of its conflicts but gained more
> against the arm-soc and slave-dma tree.
>
> ----------------------------------------------------------------------------
>

I pulled Linux v3.8-rc4 (one commit) into next-20130118.

When CONFIG_SYSTEM_TRUSTED_KEYRING=n I see these error-messages on AMD64:

  CC      security/keys/keyring.o
  CC      kernel/module_signing.o
  CC [M]  arch/x86/kvm/i8259.o
kernel/module_signing.c: In function 'request_asymmetric_key':
kernel/module_signing.c:161:36: error: 'system_trusted_keyring'
undeclared (first use in this function)
kernel/module_signing.c:161:36: note: each undeclared identifier is
reported only once for each function it appears in
make[3]: *** [kernel/module_signing.o] Error 1
make[2]: *** [kernel] Error 2
make[2]: *** Waiting for unfinished jobs....

- Sedat -
