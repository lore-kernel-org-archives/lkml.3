Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbaDPSnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:43:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:49533 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbaDPSnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:43:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
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
Date: Wed, 16 Apr 2014 20:42:39 +0200
Message-ID: <6356054.sn5XpK65Cm@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140416194109.3ef914d2@alan.etchedpixels.co.uk>
References: <1397668411-27162-7-git-send-email-ynvich@gmail.com> <1397668667-27328-7-git-send-email-ynvich@gmail.com> <20140416194109.3ef914d2@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:W4WnsSmAxCcvOduGJCov+dF9RwKYnualMM9nRTrQMiP
 MDVDhI9O2wL8rzrzq5m+Hl9QmXyyd8jmydlfEoXRj17fUed+KQ
 xbmeWCn2o9hJAODKijpowIjT+ZDhumbpEu6QYfUl5K+rpyM6Kn
 b8xRfGwTeMnYogoOF8RqMWGJlfCNmpavVEkjo3ICCqUUMfg6Qd
 f031uC+Akq5PeU2ICN5lbsc7GUcF0haJvzx6PINcJnZ+yziN5n
 ZNRFglE1OSAled4Cp3eLST4AHeJNPYDVESyUinQJgJjQxECB+I
 N9S+bnb19G29Tvg2ihph4dU0Kj94yU6JSXI1SaTNCuM7qhlkaa
 y5DpYQmqMq4xrvks5WNw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2014 19:41:09 One Thousand Gnomes wrote:
> On Wed, 16 Apr 2014 21:17:18 +0400
> Sergei Ianovich <ynvich@gmail.com> wrote:
> 
> > This patch implements probing for the bus and reporting the number
> > of available expansion slots.
> 
> This appears to be a bus not a misc device. I don't think it belongs in
> misc. As you've got devices on this bus (or nailed into the 'bus' driver)
> perhaps this belongs as drivers/platform/lp8x4x or similar with any
> specific drivers split out - or even drivers/lp8x4x if there will be more
> of them and more than one platform using it ?

We have drivers/bus now, I think it could fit well in there.

	Arnd
