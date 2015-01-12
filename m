Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbbALQJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:09:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:30543 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbbALQJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:09:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,744,1413270000"; 
   d="scan'208";a="649876591"
Message-ID: <1421078918.31978.32.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/4] tty: serial: Add 8250 earlycon to support noinit
 option
From: Alan Cox <alan@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Eddie Huang <eddie.huang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
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
        "Joe.C" <yingjoe.chen@mediatek.com>, Jiri Slaby <jslaby@suse.cz>
Date: Mon, 12 Jan 2015 16:08:38 +0000
In-Reply-To: <3712986.8SuKNvhKTk@wuerfel>
References: <1421068104-30463-1-git-send-email-eddie.huang@mediatek.com>
	 <1421068104-30463-2-git-send-email-eddie.huang@mediatek.com>
	 <3712986.8SuKNvhKTk@wuerfel>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9 (3.12.9-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 16:35 +0100, Arnd Bergmann wrote:
> On Monday 12 January 2015 21:08:21 Eddie Huang wrote:
> > Add earlycon support not only baudrate option, but also add noinit option.
> > If use noinit option, 8250 earlycon will not init serial hardware and use
> > loader setting.
> > 
> > Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
> 
> I probably missed something in the previous discussion, but why is
> "noinit" not just the default? I believe that is how we handle early
> serial ports on PowerPC, and I see no downsides to it.

Most PC hardware at least needs the port initialised to use it. It won't
have been configured by the firmware in many cases.

Alan


