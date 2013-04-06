Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab3DFGMl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 02:12:41 -0400
Received: from purkki.adurom.net ([80.68.90.206]:35584 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321Ab3DFGMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 02:12:40 -0400
X-Greylist: delayed 1217 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Apr 2013 02:12:40 EDT
From: Kalle Valo <kvalo@adurom.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Adrian Chadd <adrian@freebsd.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Version number policy!
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com>
	<CAB=NE6V3sApMSGWkKbaFaJC4+VpLxgYF-xyNRKxiA-YDCwhGkQ@mail.gmail.com>
	<201304051903.11215.chunkeey@googlemail.com>
	<CAFSJ42bqquh+xekt8+V3wbG3MOUVFELTxR3mNPfS0Jn9J7OURQ@mail.gmail.com>
Date: Sat, 06 Apr 2013 08:52:19 +0300
In-Reply-To: <CAFSJ42bqquh+xekt8+V3wbG3MOUVFELTxR3mNPfS0Jn9J7OURQ@mail.gmail.com>
	(Eugene Krasnikov's message of "Fri, 5 Apr 2013 19:23:54 +0200")
Message-ID: <8762008auk.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eugene Krasnikov <k.eugene.e@gmail.com> writes:

> Good point regarding timestamp.
>
> When it comes to feature bitmap do you have an example of such a
> bitmap from carl9170? Why not to rely always on major version?

I'm with Christian here. In ath6kl we switched to firmware advertising
feature capabilities and I have never looked back, it's so much easier.
You don't need to do any mapping between firmware versions and features,
you just deal one feature at a time.

-- 
Kalle Valo
