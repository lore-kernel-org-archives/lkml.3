Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3LCMSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:18:32 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:35219 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3LCMSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:18:30 -0500
Date: Tue, 3 Dec 2013 21:18:27 +0900
From: Simon Horman <horms@verge.net.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 03/03] pinctrl: sh-pfc: r7s72100 SCIF2 port4, 6 and 8
 support
Message-ID: <20131203121827.GE21976@verge.net.au>
References: <20131127080606.18384.45103.sendpatchset@w520>
 <20131127080640.18384.21957.sendpatchset@w520>
 <CACRpkdZMLe-uGPY0psjC_6+kdJecAvnjddnJTMkMNzg43DooiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZMLe-uGPY0psjC_6+kdJecAvnjddnJTMkMNzg43DooiA@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 10:36:54AM +0100, Linus Walleij wrote:
> On Wed, Nov 27, 2013 at 9:06 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
> 
> > From: Magnus Damm <damm@opensource.se>
> >
> > Add the remaining SCIF2 pins using the recently introduced macro.
> >
> > Signed-off-by: Magnus Damm <damm@opensource.se>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Laurent, please pick this into your stack for my tree.
> 
> I guess the pure DTS changes can go directly to Simon's tree?

Yes, I'll pick them up.
