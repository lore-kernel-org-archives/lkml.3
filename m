Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3KQTyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 14:54:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40347 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab3KQTyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 14:54:31 -0500
Date: Sun, 17 Nov 2013 20:53:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Francis Moreau <francis.moro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131117195358.GO27323@pd.tnic>
References: <52888F6D.6000802@gmail.com>
 <20131117132531.GB27696@pd.tnic>
 <5288E5BF.2020608@gmail.com>
 <20131117160126.GG27323@pd.tnic>
 <CAC9WiBikz8kTAmKs1HVBmeb2Wu6hfHCh2d=w1sQC03EVHa1QOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAC9WiBikz8kTAmKs1HVBmeb2Wu6hfHCh2d=w1sQC03EVHa1QOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 07:02:21PM +0100, Francis Moreau wrote:
> Sorry I haven't taken the original picture large enough, and getting
> this kernel panic is pretty hard since the kernel usually displays the
> black screen.

Ok, just try to make a readable picture of the whole line, next time you
trigger it.

> I can't find any traces of this function in the dump...

Hmm, strange. Can you upload the whole vmlinux somewhere? Or is this the
official archlinux kernel? If so, where can I get it from?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
