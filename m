Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3DUQjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 12:39:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42524 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab3DUQjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 12:39:13 -0400
Date: Sun, 21 Apr 2013 18:39:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Slaby <jslaby@suse.cz>, John Stultz <john.stultz@linaro.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Resume does not work after timekeeping change
Message-ID: <20130421163910.GA4585@pd.tnic>
References: <5172B86C.5030606@suse.cz>
 <alpine.LFD.2.02.1304211648150.21884@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1304211648150.21884@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 04:48:45PM +0200, Thomas Gleixner wrote:
> Does the patch below fix the issue?

It does here.

Applied it ontop of tip/master of today and did three suspend/resume
cycles, back-to-back - looks good and no hickups.

Tested-by: Borislav Petkov <bp@suse.de>

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
