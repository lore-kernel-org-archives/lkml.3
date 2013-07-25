Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3GYPxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:53:17 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:53362 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3GYPxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:53:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130724231050.GA29499@kroah.com>
References: <1370452543-19014-1-git-send-email-yhchen@faraday-tech.com>
	<1371671584-8181-1-git-send-email-yhchen@faraday-tech.com>
	<20130724231050.GA29499@kroah.com>
Date: Thu, 25 Jul 2013 23:53:11 +0800
Message-ID: <CADB-GoL12drca75mQ3vcxTA30tardJHWW=+Aq0YLLsF1p=n8ZQ@mail.gmail.com>
Subject: Re: [PATCH v2] usb: host: Faraday fotg210-hcd driver
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Yuan-Hsin Chen <yhchen@faraday-tech.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, florian@openwrt.org,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        ratbert <ratbert.chuang@gmail.com>,
        =?UTF-8?B?Sm9obiBGZW5nLUhzaW4gQ2hpYW5nKOaxn+WzsOiIiCk=?= 
	<john453@faraday-tech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Thu, Jul 25, 2013 at 7:10 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jun 19, 2013 at 07:53:04PM +0000, Yuan-Hsin Chen wrote:
> > FOTG210 is an OTG controller which can be configured as an
> > USB2.0 host. FOTG210 host is an ehci-like controller with
> > some differences. First, register layout of FOTG210 is
> > incompatible with EHCI. Furthermore, FOTG210 is lack of
> > siTDs which means iTDs are used for both HS and FS ISO
> > transfer.
> >
> > Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
>
> As your email now is bouncing, I'm going to revert this patch, I can't
> take a patch for a driver with no active maintainer, sorry.
>
> If someone else from Faraday will step up and maintain this, that would
> be great, please resend it with your email information.

I see. My ex-colleague who takes over the driver will resend the patch later.

Thanks.

Yuan-Hsin

>
> thanks,
>
> greg k-h
