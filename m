Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbaJ2JoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:44:16 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60206 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbaJ2JoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:44:14 -0400
From: "Javi Merino" <javi.merino@arm.com>
Date: Wed, 29 Oct 2014 09:44:08 +0000
To: Peter Feuerer <peter@piie.net>
Cc: Zhang Rui <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/6] thermal: Added Bang-bang thermal governor
Message-ID: <20141029094407.GA2692@e104805>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1406043436-17068-1-git-send-email-peter@piie.net>
 <1406043436-17068-4-git-send-email-peter@piie.net>
 <cone.1406384086.541895.7413.1000@galar>
 <1406514389.14109.7.camel@rzhang1-toshiba>
 <cone.1413887350.971616.2744.1000@mups>
 <cone.1414524819.964570.994.1000@galar>
MIME-Version: 1.0
In-Reply-To: <cone.1414524819.964570.994.1000@galar>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 29 Oct 2014 09:44:08.0336 (UTC) FILETIME=[E2B92900:01CFF35C]
X-MC-Unique: 114102909441101201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 07:33:39PM +0000, Peter Feuerer wrote:
> Hi Rui,
> 
> I wonder whether you've had time to apply my set of patches already?  Would 
> you please be so kind to just send me a short reply?

The bang-bang governor was merged and is part of v3.18-rc2:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8264fce6de03f3915e2301f52f181a982718a8cb

Cheers,
Javi

> Peter Feuerer writes:
> 
> > Hi Rui,
> > 
> > Zhang Rui writes:
> > 
> >> On Sat, 2014-07-26 at 16:14 +0200, Peter Feuerer wrote:
> >>> Hi Rui,
> >>> 
> >>> Peter Feuerer writes:
> >>> 
> >>> > The bang-bang thermal governor uses a hysteresis to switch abruptly on
> >>> > or off a cooling device.  It is intended to control fans, which can
> >>> > not be throttled but just switched on or off.
> >>> > Bang-bang cannot be set as default governor as it is intended for
> >>> > special devices only.  For those special devices the driver needs to
> >>> > explicitely request it.
> >>> > 
> >>> > Cc: Andrew Morton <akpm@linux-foundation.org>
> >>> > Cc: Zhang Rui <rui.zhang@intel.com>
> >>> 
> >>> Anything that prevents you from giving your acked-by?
> >>> 
> >> NO.
> >> 
> >> I'll queue them for 3.18.
> > 
> > Are all 6 patches in for 3.18 as you promissed?
> > 
> > kind regards,
> > --peter;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

