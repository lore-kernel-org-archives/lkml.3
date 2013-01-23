Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab3AWMxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:53:16 -0500
Received: from 14.mo3.mail-out.ovh.net ([188.165.43.98]:42584 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754737Ab3AWMxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:53:15 -0500
X-Greylist: delayed 7498 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jan 2013 07:53:15 EST
Date: Wed, 23 Jan 2013 13:42:00 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        richard.genoud@gmail.com, linux-arm@overkiz.com, manabian@gmail.com,
        dgilbert@interlog.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Josh Wu <josh.wu@atmel.com>,
        Bo Shen <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 7/9] ARM: at91/at91_dt_defconfig: remove memory
 specification to cmdline
Message-ID: <20130123124200.GK7360@game.jcrosoft.org>
References: <cover.1358934163.git.nicolas.ferre@atmel.com>
 <2e06e92c758b768baaacc061aafa7f710b74ea02.1358934163.git.nicolas.ferre@atmel.com>
 <20130123102057.GJ7360@game.jcrosoft.org>
 <50FFCC92.2080906@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FFCC92.2080906@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 15773294746474556268
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrjeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrjeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:42 Wed 23 Jan     , Nicolas Ferre wrote:
> On 01/23/2013 11:20 AM, Jean-Christophe PLAGNIOL-VILLARD :
> > On 10:48 Wed 23 Jan     , Nicolas Ferre wrote:
> >> No need for this cmdline option as we are using DT.
> >> Moreover this defconfig is targeted to multiple SoC/boards: this option
> >> was nonsense.
> > just keep the console the rest is a nonsense too
> > 
> > as on 9g45 the initrd will be at 0x7xxxxxxx
> 
> BTW, how do you mix 9g45 with other sam9's in this defconfig: it is not
> possible due to this difference in address rage, it not it?
> 
> In this case, should we remove the
> CONFIG_SOC_AT91SAM9G45=y
> from this at91_dt_defconfig?
no you just need to boot the zImage from barebox

barebox handle automaticaly where the kernel is supposed to run
and the kernel found his running/decompressing address at runtime too

Best Regards,
J.
