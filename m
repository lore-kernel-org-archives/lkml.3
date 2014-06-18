Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaFRUnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:43:55 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:49231 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbaFRUnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:43:53 -0400
Date: Wed, 18 Jun 2014 23:43:44 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: devicetree@vger.kernel.org, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
        Pawel Moll <pawel.moll@arm.com>, Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@debian.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] omap3-n900.dts: Rename model name to "Nokia RX-51 board"
Message-ID: <20140618204344.GC558@drone.musicnaut.iki.fi>
References: <1403110635-29696-1-git-send-email-pali.rohar@gmail.com>
 <20140618201241.GB558@drone.musicnaut.iki.fi>
 <201406182223.03420@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201406182223.03420@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 18, 2014 at 10:23:03PM +0200, Pali Rohár wrote:
> On Wednesday 18 June 2014 22:12:41 Aaro Koskinen wrote:
> > On Wed, Jun 18, 2014 at 06:57:15PM +0200, Pali Rohár wrote:
> > > Use same name as in legacy board code. There are lot of
> > > userspace applications which using machine/model name for
> > > determinating device type.
> > 
> > Can you clarify this? Nokia kernel or userspace never had DT,
> > so they cannot see e.g. /proc/device-tree/model. What other
> > APIs expose model?
> 
> Basically that patch export model name in Hardware /proc/cpuinfo 
> instead generic DT name. And this patch change name to what 
> legacy board code reported.

I don't like the idea of changing the model name from Nokia
marketing names to those cryptic internal names in DT files.
There also may be already some userspace relying to find current model
name from /proc/device-tree/model (e.g. I think my own OS would break).

A.
