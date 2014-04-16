Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161197AbaDPUaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:30:52 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47152 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068AbaDPUau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:30:50 -0400
Date: Wed, 16 Apr 2014 21:29:19 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sergei Ianovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 13/21] misc: support for LP-8x4x custom parallel bus
Message-ID: <20140416212919.7f6f35ac@alan.etchedpixels.co.uk>
In-Reply-To: <6356054.sn5XpK65Cm@wuerfel>
References: <1397668411-27162-7-git-send-email-ynvich@gmail.com>
	<1397668667-27328-7-git-send-email-ynvich@gmail.com>
	<20140416194109.3ef914d2@alan.etchedpixels.co.uk>
	<6356054.sn5XpK65Cm@wuerfel>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014 20:42:39 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 16 April 2014 19:41:09 One Thousand Gnomes wrote:
> > On Wed, 16 Apr 2014 21:17:18 +0400
> > Sergei Ianovich <ynvich@gmail.com> wrote:
> > 
> > > This patch implements probing for the bus and reporting the number
> > > of available expansion slots.
> > 
> > This appears to be a bus not a misc device. I don't think it belongs in
> > misc. As you've got devices on this bus (or nailed into the 'bus' driver)
> > perhaps this belongs as drivers/platform/lp8x4x or similar with any
> > specific drivers split out - or even drivers/lp8x4x if there will be more
> > of them and more than one platform using it ?
> 
> We have drivers/bus now, I think it could fit well in there.

Agreed
