Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaLaN6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:58:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51268 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbaLaN6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:58:00 -0500
Date: Wed, 31 Dec 2014 14:57:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] x86/boot/early_serial_console: Remove unnecessary
 check
Message-ID: <20141231135758.GB6332@pd.tnic>
References: <1420009958-4803-1-git-send-email-kuleshovmail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420009958-4803-1-git-send-email-kuleshovmail@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 01:12:38PM +0600, Alexander Kuleshov wrote:
> There is already the same check before.
> 
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
