Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaBXCLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 21:11:19 -0500
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:48438 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbaBXCLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 21:11:14 -0500
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <530AAA38.3090700@iki.fi>
Date: Mon, 24 Feb 2014 04:11:04 +0200
From: Anssi Hannula <anssi.hannula@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michal_Mal=FD?= <madcatxster@prifuk.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, elias.vds@gmail.com, jkosina@suse.cz,
        simon@mungewell.org
Subject: Re: [PATCH v2 1/4] Add ff-memless-next driver
References: <1516865.M993BQAYe4@geidi-prime> <3364546.xScl1m6sdc@geidi-prime> <530A931D.9030308@iki.fi> <1651798.4YaLXnucpJ@geidi-prime>
In-Reply-To: <1651798.4YaLXnucpJ@geidi-prime>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

24.02.2014 03:54, Michal Malý kirjoitti:
> I forgot to comment on this:
>> Stopped effects should still be able to be updated.
> Fair enough. I could not find a definitive answer to what is expected behavior 
> in this case. As far as I can tell, there are following cases:
> - Effects with no duration and delay: they shall be updated right away.
> - Effects with delay: updated parameters shall be sent to the device at the 
> correct time.
> - "Expired" effects with finite duration - ??? I assumed that effects with 
> finite duration that have already finished playing cannot be updated because 
> it does not seem to make much sense to do so.

"Expired" effects can always be played back again later - if that
happens, the updated parameters will be in effect.

> Shall such an effect be 
> restarted when it is updated?

No.

> Is there any guideline I should stick to I am 
> not aware of?

Only "3.7 Dynamic update of an effect" of input/ff.txt.

-- 
Anssi Hannula
