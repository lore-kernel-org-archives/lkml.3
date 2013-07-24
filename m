Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3GXIAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:00:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33975 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab3GXIAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:00:12 -0400
Date: Wed, 24 Jul 2013 10:00:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86, AMD: fix error path in apply_microcode_amd()
Message-ID: <20130724080006.GC30777@pd.tnic>
References: <20130723225823.2e4e7588@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130723225823.2e4e7588@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 10:58:23PM +0200, Torsten Kaiser wrote:
> Return -1 (like Intels apply_microcode) when the loading fails, also
> do not set the active microcode level on failure.
> 
> Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>

Acked-by: Borislav Petkov <bp@suse.de>

@hpa: this is a fix for a76096a6571d5 which went in during this merge
window so queue it for tip-urgent please.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
