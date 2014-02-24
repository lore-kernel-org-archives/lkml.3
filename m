Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbaBXByS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 20:54:18 -0500
Received: from www.prifuk.cz ([31.31.77.241]:41712 "EHLO prifuk.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbaBXByQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 20:54:16 -0500
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, elias.vds@gmail.com, jkosina@suse.cz,
        simon@mungewell.org
Subject: Re: [PATCH v2 1/4] Add ff-memless-next driver
Date: Mon, 24 Feb 2014 02:54:11 +0100
Message-ID: <1651798.4YaLXnucpJ@geidi-prime>
User-Agent: KMail/4.12.2 (Linux/3.13.5-1-ARCHMOD; KDE/4.12.2; x86_64; ; )
In-Reply-To: <530A931D.9030308@iki.fi>
References: <1516865.M993BQAYe4@geidi-prime> <3364546.xScl1m6sdc@geidi-prime> <530A931D.9030308@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to comment on this:
> Stopped effects should still be able to be updated.
Fair enough. I could not find a definitive answer to what is expected behavior 
in this case. As far as I can tell, there are following cases:
- Effects with no duration and delay: they shall be updated right away.
- Effects with delay: updated parameters shall be sent to the device at the 
correct time.
- "Expired" effects with finite duration - ??? I assumed that effects with 
finite duration that have already finished playing cannot be updated because 
it does not seem to make much sense to do so. Shall such an effect be 
restarted when it is updated? Is there any guideline I should stick to I am 
not aware of?

Michal M.
