Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3J2Jmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:42:32 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.114]:11072 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587Ab3J2Jm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:42:29 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-14.tower-194.messagelabs.com!1383039745!13830350!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 29 Oct 2013 10:42:26 +0100
Date: Tue, 29 Oct 2013 10:42:19 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Wim Van Sebroeck <wim@iguana.be>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Guenter Roeck <linux@roeck-us.net>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH] documentation/devicetree: Move DT bindigns from gpio to
 watchdog
Message-ID: <20131029094219.GA25358@jtlinux>
References: <1377088929-23694-1-git-send-email-johannes.thumshirn@men.de>
 <20131029074153.GE19569@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131029074153.GE19569@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 29 Oct 2013 09:42:24.0918 (UTC) FILETIME=[2C4E1360:01CED48B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 08:41:53AM +0100, Wim Van Sebroeck wrote:
> Hi Johannes,
>
> > I accidently put the devicetree bindings for the MEN A21 watchdog driver in
> > Documentation/devicetree/bindings/gpio instead of
> > Documentation/devicetree/bindings/watchdog, this patch addresses this error.
> >
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: Pawel Moll <pawel.moll@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Stephen Warren <swarren@wwwdotorg.org>
> > Cc: Ian Campbell <ian.campbell@citrix.com>
> > Cc: Rob Landley <rob@landley.net>
> > Cc: Wim Van Sebroeck <wim@iguana.be>
> > Cc: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  .../bindings/{gpio => watchdog}/men-a021-wdt.txt   |    0
> >  1 file changed, 0 insertions(+), 0 deletions(-)
> >  rename Documentation/devicetree/bindings/{gpio => watchdog}/men-a021-wdt.txt (100%)
> >
> > diff --git a/Documentation/devicetree/bindings/gpio/men-a021-wdt.txt b/Documentation/devicetree/bindings/watchdog/men-a021-wdt.txt
> > similarity index 100%
> > rename from Documentation/devicetree/bindings/gpio/men-a021-wdt.txt
> > rename to Documentation/devicetree/bindings/watchdog/men-a021-wdt.txt
>
> This patch has been added to linux-watchdog-next.
>
> Kind regards,
> Wim.
>

Thanks Wim

       Johannes
