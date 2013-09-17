Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3IQPga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:36:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50804 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3IQPg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:36:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: old trees
Date: Tue, 17 Sep 2013 17:36:12 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
References: <20130917170124.0afa2e103a9977355ad7c72c@canb.auug.org.au>
In-Reply-To: <20130917170124.0afa2e103a9977355ad7c72c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201309171736.12482.arnd@arndb.de>
X-Provags-ID: V02:K0:oHEToDKM4qFc51RmH5kITt9elgivex3nahSZm7Xd6w9
 v9UL/wasOekc/cAgpeJmcDBZ0dC9x0ivuhuYcto1rru6ouvJQf
 CMQfNwSXejWzz7ddETCcgMu6xbDfTc9PKEIpGTy0V0vFy7Ve3b
 OCRy7olbMApsh5lsafCrdJxTaurUXWJIQwkv8XtrplYBa5tJV/
 TTS7OeDv7/te+4yihEsHv/c4Lskgs6v4evJA1O7KMyxlp6POp4
 wkXJYbzgqJ90VOrIStnbKYZzmdJ1vg9ibA1oSfoMI2NytuXpf1
 SOSPC1U4HOoLsjPI80SgvIpSy7jjHzTdbciI5Q2m+LQhn6Jltb
 BBVl4oE/snahrWsXApcs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 September 2013, Stephen Rothwell wrote:
> asm-generic     9 months ago

I occasionally use this tree, but in most releases all asm-generic patches tend to
go along with whatever patch series needs them, since asm-generic changes are
typically done whenever we add some code to the kernel elsewhere. Please keep this
one.

	Arnd
