Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3GWFDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 01:03:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35286 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab3GWFDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 01:03:15 -0400
Date: Tue, 23 Jul 2013 07:03:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RTC: Add an alarm disable quirk
Message-ID: <20130723050311.GA8497@pd.tnic>
References: <1374162294-29726-1-git-send-email-bp@alien8.de>
 <51E8194E.1030704@linaro.org>
 <20130718225349.GD15992@pd.tnic>
 <20130719142628.GC19581@pd.tnic>
 <20130719151321.GD19581@pd.tnic>
 <51ED9D15.3010304@linaro.org>
 <20130722211223.GC4613@pd.tnic>
 <51EDA10D.6040207@linaro.org>
 <20130722212746.GE4613@pd.tnic>
 <51EDAF7D.3000605@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51EDAF7D.3000605@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 03:17:33PM -0700, John Stultz wrote:
> Thanks again for your interest in hunting this down.

Yeah, "interest" is a good euphemism for "it pisses the h*ll out of me"
:-)

Btw, the failing box runs a SLED11 kernel (3.0.x + a lot of patches)
while the good box will run latest upstream. Let's see how relevant that
would be wrt rtc-cmos.

Let me start playing and see how far we can go...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
