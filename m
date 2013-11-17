Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3KQN0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 08:26:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55906 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab3KQN0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 08:26:04 -0500
Date: Sun, 17 Nov 2013 14:25:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Francis Moreau <francis.moro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131117132531.GB27696@pd.tnic>
References: <52888F6D.6000802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52888F6D.6000802@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 10:42:05AM +0100, Francis Moreau wrote:
> Today I got a different behaviour, after resuming I got a
> kernel panic. I could take a picture of the laptop screen:
> http://imgur.com/f5uWFTY

Does archlinux ship the upstream kernel or do they have patches ontop?
If "yes" to the last one, try reproducing this panic with the upstream
kernel 3.12.

In general, how reliably can you reproduce the kernel panic with the
upstream 3.12 kernel?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
