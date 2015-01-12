Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbbALPg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:36:29 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:57329 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbbALPg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:36:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Eddie Huang <eddie.huang@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, devicetree@vger.kernel.org,
        Vladimir Murzin <vladimir.murzin@arm.com>, srv_heupstream@mediatek.com,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yh.chen@mediatek.com, Howard Chen <ibanezchen@gmail.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        linux-serial@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH v2 1/4] tty: serial: Add 8250 earlycon to support noinit option
Date: Mon, 12 Jan 2015 16:35:19 +0100
Message-ID: <3712986.8SuKNvhKTk@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1421068104-30463-2-git-send-email-eddie.huang@mediatek.com>
References: <1421068104-30463-1-git-send-email-eddie.huang@mediatek.com> <1421068104-30463-2-git-send-email-eddie.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:73nCKDAI6fV2gY3EG8lHBQy/glegCTCWLHXSbke5RB/be1ACU4Q
 TFE2sDJhS7BYmTQeRIsdI8TNCq+C5xAon56EGAnqwPLzbEQBGnA3FzDwADkbT3lEj9HwcCJ
 mnapKPC5BPHbBoNrpAWNMdPLVloAr21mgVe0aZpFc1N4Zj/XWnY1UqzpcfVsMbFABJUp5LZ
 B48IWCG3Q5968d0YrGlxQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2015 21:08:21 Eddie Huang wrote:
> Add earlycon support not only baudrate option, but also add noinit option.
> If use noinit option, 8250 earlycon will not init serial hardware and use
> loader setting.
> 
> Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>

I probably missed something in the previous discussion, but why is
"noinit" not just the default? I believe that is how we handle early
serial ports on PowerPC, and I see no downsides to it.

	Arnd
