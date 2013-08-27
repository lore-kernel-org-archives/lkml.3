Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab3H0TWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:22:53 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59181 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab3H0TWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:22:52 -0400
Date: Tue, 27 Aug 2013 21:22:51 +0200
From: Andreas Mohr <andi@lisas.de>
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.11-rc6 many problems, wil6210 , snd-pcsp , ibmphp
Message-ID: <20130827192251.GA31552@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <web-25718928@zbackend1.aha.ru>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> /  The snd-pcsp  module don't work.    It don't load even 
> with option snd-pcsp index=1 , it gives a message that the 
> device is
> ocupied.   Typing in   beep  , it's beeping, so I suppose 
> my computer has a beeper.   Perhaps any default speaker 
> module occupies
> the speaker ?   It should be programmed correctly in the 
> pcsp module, that loading it it desocupy the speaker. 
>    The beeper
> programming specialist should check this module, I tried 
> it for several kernel versions and computers, it never 
> works.

Have to provide a "me too". Was interested in it when it first appeared
in kernel in semi-recentish times, did not get it to work other than
producing some random clicking.
I'm very sad to say that the High-Fidelity-Enhanced speaker driver
in Windows 3.11 worked a lot better than this and was actually
semi-acceptable as a soundcard replacement.
Wait - aren't we at version 3.11 now, too? So shouldn't this now just
work, too? </cheap_shot>
Especially given our very advanced timer handling compared to those
primitive OSes, I'd definitely expect device performance
to be somewhat *better* not worse...

> That facility is important because persons in poorer 
> places have old computers without sound cards.

Indeed. While this argument is getting harder to make by the minute
(with many soundcards builtin, almost for decades),
it does have some merit (even if it's just to provide a minimally usable replacement
for a cheapo broken soundcard hardware, or for - God forbid! - soundcard
hardware unsupported by Linux).

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
