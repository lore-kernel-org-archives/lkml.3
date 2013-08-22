Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3HVEWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 00:22:22 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:60685 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3HVEWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 00:22:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130822004514.GB19747@xanatos>
References: <1377040909-18428-1-git-send-email-jwerner@chromium.org>
	<20130821184042.GC3577@xanatos>
	<CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
	<20130822004514.GB19747@xanatos>
Date: Wed, 21 Aug 2013 21:22:19 -0700
X-Google-Sender-Auth: V1Pn1YZeNKr-8wB3IKziSllFcXM
Message-ID: <CAODwPW99gLBtNQD=UyPq9DqY0TtNubR_7e+FymkfO5u2+et++Q@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        mathias.nyman@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You need the USB 2.0 spec errata from 2011-11 that describes the changes
> made for BESL as well.  It's in the USB2-LPM-Errata-final.pdf and
> USB2_LinkPowerMangement_ECN[final].pdf files in this zip file:
>
> http://www.usb.org/developers/docs/usb_20_070113.zip
>
> I agree though, it's all a confusing mess for documentation on USB 2.0
> Link PM.

Thanks, I hadn't found that first one yet. Do you also have a link for
the updated XHCI specification or a separate erratum document
describing the PORTHLPMC register referenced in the BESL patches (they
don't exist on DWC3, but I'm still curious)?
