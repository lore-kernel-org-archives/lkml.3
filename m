Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965118Ab3DHPdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:33:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51685 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942Ab3DHPdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:33:16 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: Re: Version number policy!
Date: Mon, 8 Apr 2013 17:33:15 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc5-wl-wl+; KDE/4.8.4; x86_64; ; )
Cc: Adrian Chadd <adrian@freebsd.org>, Kalle Valo <kvalo@adurom.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "linux-bluetooth" <linux-bluetooth@vger.kernel.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "ath9k_htc_fw" <ath9k_htc_fw@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com> <CAJ-VmomQaYFMR0G1DM+dno6qB+AdXUom8=kWPzJoOjuzQj81bw@mail.gmail.com> <CAFSJ42Zd3s8xKwt4X3LNcupCTntDULxNntMuD-_Xh6_csiGA4A@mail.gmail.com>
In-Reply-To: <CAFSJ42Zd3s8xKwt4X3LNcupCTntDULxNntMuD-_Xh6_csiGA4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201304081733.15727.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 08, 2013 11:10:30 AM Eugene Krasnikov wrote:
> It’s a good idea to pack bitmap into the tail/header of the firmware
> binary to get capabilities even before fw loading. The plan is to add
> 8 bytes for caps and also add time stamp. Let me play around with that
> and provide fw and driver patch for review.

Hm, come to think of it. Kalle, do you think ath9k_htc could use
some bits of the fw header format, parser or the complete infrastructure
from ath6kl? This could be great for Adrian, because he could
just point people to it and they could moved it into the code
into /drivers/net/wireless/ath/fw.c.

Regards,
	Christian
