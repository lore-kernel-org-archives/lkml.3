Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3I2Vaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 17:30:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59427 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab3I2Vag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 17:30:36 -0400
Date: Sun, 29 Sep 2013 23:30:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Torvalds <torvalds@osdl.org>, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH 1/1] x86_64: add config options to optimize for newer AMD
 processors
Message-ID: <20130929213026.GF5426@pd.tnic>
References: <52486938.4090009@gmail.com>
 <20130929180101.GB5490@pd.tnic>
 <5248905E.8000801@gmail.com>
 <20130929205051.GD5426@pd.tnic>
 <52489A59.7040108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52489A59.7040108@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 05:23:37PM -0400, Austin S Hemmelgarn wrote:
> I'm not saying that should just be included without substantiation, I
> simply mean that the reason to include it (as far as I am concerned)
> is that it doesn't break anything and provides something useful that
> isn't in the kernel already.

If it doesn't bring any performance improvement - and I don't want to
rain on your parade but I think it won't, at least not enough to warrant
a serious look - there's absolutely no reason to add it.

But hey, I'm always open to surprises! So surprise me!

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
