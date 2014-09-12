Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaILQzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:55:04 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:36848 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaILQzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:55:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140912143936.GI6871@arm.com>
References: <20140912143936.GI6871@arm.com>
Date: Fri, 12 Sep 2014 09:55:01 -0700
X-Google-Sender-Auth: idPN9FPjmnx5M38wMBvw2Srlzsg
Message-ID: <CA+55aFw--qxA+-PPCSXgx1V4EHfz8hE9_rW1dH4xMLHi+Q4prg@mail.gmail.com>
Subject: Re: [GIT PULL] arm64: couple of fixes for -rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 7:39 AM, Will Deacon <will.deacon@arm.com> wrote:
>
> To keep things interesting, I've signed the tag using my Yubikey from KS.
> Given that it only supports 2048-bit keys, I've used a new subkey so you
> may need to update your keyring to verify the signature.

BTW, thanks for mentioning things like this, that would have otherwise
potentially made me waste time trying to figure out why your key
wasn't in my keyring and didn't match the old one.

              Linus
