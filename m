Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbaJ2NEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:04:02 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:56813 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680AbaJ2ND7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:03:59 -0400
Date: Wed, 29 Oct 2014 14:00:50 +0100
From: Johan Hovold <johan@kernel.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Johan Hovold <johan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        devicetree <devicetree@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, j-keerthy@ti.com, nsekhar@ti.com,
        Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        t-kristo@ti.com, Lokesh Vutla <lokeshvutla@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-ID: <20141029130050.GC2265@localhost>
References: <20141024194442.GG11455@saruman>
 <20141024195532.GF19377@localhost>
 <20141027162251.d7ff2a5f31917c638d4e47f7@linux-foundation.org>
 <20141028002552.GX12379@n2100.arm.linux.org.uk>
 <20141028081616.GL2006@localhost>
 <20141028084745.GY12379@n2100.arm.linux.org.uk>
 <20141028131257.GS2006@localhost>
 <20141028151610.GA12379@n2100.arm.linux.org.uk>
 <20141029123418.GB2265@localhost>
 <CABgxDo+ewxNwb3RrBVZA7kqYMvSujLb9U6A6FCvnHQH1W8V0kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgxDo+ewxNwb3RrBVZA7kqYMvSujLb9U6A6FCvnHQH1W8V0kg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Please do not top-post. ]

On Wed, Oct 29, 2014 at 01:55:49PM +0100, Romain Perier wrote:
> Johan:. do you really plan to use this "poweroff-source" property ? As
> you proposed a renaming few days ago...
> I don't really want to waste time to propose patches to fix things
> incrementally and rename it if the old one is used...

Why would I want to use your retracted renaming proposal for this
property (i.e. "poweroff-source")?

These patches use "ti,system-power-controller" and the vendor prefix
will be dropped when your patches have been merged.

Johan
