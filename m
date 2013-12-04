Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab3LDBJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:09:42 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:44164 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab3LDBJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:09:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 03/03] pinctrl: sh-pfc: r7s72100 SCIF2 port4, 6 and 8 support
Date: Wed, 04 Dec 2013 02:09:45 +0100
Message-ID: <5746197.aE2sFG9AJ5@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CACRpkdZMLe-uGPY0psjC_6+kdJecAvnjddnJTMkMNzg43DooiA@mail.gmail.com>
References: <20131127080606.18384.45103.sendpatchset@w520> <20131127080640.18384.21957.sendpatchset@w520> <CACRpkdZMLe-uGPY0psjC_6+kdJecAvnjddnJTMkMNzg43DooiA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tuesday 03 December 2013 10:36:54 Linus Walleij wrote:
> On Wed, Nov 27, 2013 at 9:06 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
> > From: Magnus Damm <damm@opensource.se>
> > 
> > Add the remaining SCIF2 pins using the recently introduced macro.
> > 
> > Signed-off-by: Magnus Damm <damm@opensource.se>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Laurent, please pick this into your stack for my tree.

I'd like to review it first, with the SoC documentation if possible. Magnus, 
is that something I could get access to ?

> I guess the pure DTS changes can go directly to Simon's tree?

-- 
Regards,

Laurent Pinchart

