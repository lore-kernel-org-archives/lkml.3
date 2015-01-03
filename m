Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbbACMBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 07:01:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39851 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbbACMBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 07:01:15 -0500
Date: Sat, 3 Jan 2015 13:01:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, setup: Rename BOOT_ISDIGIT_H -> BOOT_CTYPE_H
Message-ID: <20150103120112.GA30723@pd.tnic>
References: <1420267941-26390-1-git-send-email-kuleshovmail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420267941-26390-1-git-send-email-kuleshovmail@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2015 at 12:52:21PM +0600, Alexander Kuleshov wrote:
> arch/x86/boot/isdigit.h was renamed to arch/x86/boot/ctype.h at
> 6238b47b58480cd9c092600c05338dbe261b71ce.
> 
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
