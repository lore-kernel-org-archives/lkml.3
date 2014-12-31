Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaLaOP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 09:15:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35067 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaLaOP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 09:15:57 -0500
Date: Wed, 31 Dec 2014 15:15:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/boot/early_serial_console: Remove unused macro XMTRDY
Message-ID: <20141231141555.GC6332@pd.tnic>
References: <1420034191-20721-1-git-send-email-kuleshovmail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420034191-20721-1-git-send-email-kuleshovmail@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 07:56:31PM +0600, Alexander Kuleshov wrote:
> There is no write to serial routine, no need in XMTRDY macro.
> 
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
