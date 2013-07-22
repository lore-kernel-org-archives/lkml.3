Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab3GVVM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:12:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50326 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376Ab3GVVM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:12:27 -0400
Date: Mon, 22 Jul 2013 23:12:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RTC: Add an alarm disable quirk
Message-ID: <20130722211223.GC4613@pd.tnic>
References: <1374162294-29726-1-git-send-email-bp@alien8.de>
 <51E8194E.1030704@linaro.org>
 <20130718225349.GD15992@pd.tnic>
 <20130719142628.GC19581@pd.tnic>
 <20130719151321.GD19581@pd.tnic>
 <51ED9D15.3010304@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51ED9D15.3010304@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 01:59:01PM -0700, John Stultz wrote:
> So did this work some of the time, but not all? Or was the behavior
> totally unchanged with this?

Yep, some of the time. The first couple of runs it worked and I was
euphoric and then it rebooted and I almost threw the box out the window
:-)


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
