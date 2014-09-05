Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaIEVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:09:28 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63982 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbaIEVJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:09:26 -0400
Message-ID: <540A267E.1070002@redhat.com>
Date: Fri, 05 Sep 2014 23:09:18 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM changes for 3.17-rc4
References: <1409912186-22968-1-git-send-email-pbonzini@redhat.com> <CA+55aFxum+O9j4ohV=BwJR_+q+hMAZ2QLp0SpgZzYFWs9F=EUg@mail.gmail.com> <alpine.DEB.2.10.1409052254450.5472@nanos>
In-Reply-To: <alpine.DEB.2.10.1409052254450.5472@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/09/2014 22:58, Thomas Gleixner ha scritto:
> Nothing new there. Forgot to push out, or perhaps to use "-f" to
> overwrite the previous tag of the same name?

It's there now.  Probably a --dry-run too much (I have
push=+refs/tags/for-linus:refs/tags/for-linus in the remote configuration).

> And even if there would be something, please do not pull the top most
> commit b11ba8c62be3eb (KVM: x86: fix kvmclock breakage from timers
> branch merge).
> 
> That one is blantanly wrong and just hacks badly around a brown
> paperbag bug in the core timekeeping code, which I introduced in the
> last overhaul.

It's not wrong, it's just different.  The commit message says clearly
that besides acting as a workaround, I find the patched code easier to
understand, and I clearly stated the same in the tag message.

Paolo
