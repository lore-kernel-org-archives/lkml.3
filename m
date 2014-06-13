Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaFMTHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 15:07:09 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:53555 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaFMTHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 15:07:07 -0400
Date: Fri, 13 Jun 2014 19:07:05 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, kishon@ti.com, george.cherian@ti.com, balbi@ti.com,
        balajitk@ti.com, hdegoede@redhat.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Nikhil Devshatwar <nikhil.nd@ti.com>,
        Benoit Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH v4 3/4] ARM: DRA7: hwmod: Add ocp2scp3 and sata hwmods
In-Reply-To: <1398274559-24777-1-git-send-email-rogerq@ti.com>
Message-ID: <alpine.DEB.2.02.1406131901340.340@utopia.booyaka.com>
References: <1398274237-24510-1-git-send-email-rogerq@ti.com> <1398274559-24777-1-git-send-email-rogerq@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Wed, 23 Apr 2014, Roger Quadros wrote:

> From: Nikhil Devshatwar <nikhil.nd@ti.com>
> 
> Add hwmods for ocp2scp3 and sata modules.
> 
> [Roger Q] Clean up.

Sorry for the delay on this.  Have been corresponding with TI to figure 
out what to do about these DRA7xx/AM43xx patches, since I don't have 
boards or public documentation for these devices, so it's impossible for 
me to meaningfully review the patches.  Looks like boards and/or public 
docs won't be coming any time soon.

So for my part, here's what I'll need to merge any hwmod patches that 
involve AM437x or DRA7xx:

1. A Reviewed-by: from one of the following folks (which should come from 
a different person than who is submitting the patches):

Roger Quadros
Nishanth Menon
Rajendra Nayak
Kevin Hilman
Tony Lindgren

2. A Tested-by: from one of the following folks (who can be the same as 
the person who is the same as the person who is submitting the patches):

Nishanth Menon
Rajendra Nayak
Kevin Hilman 
Tony Lindgren

Once these are in place, I'd be happy to queue it for 3.16.


- Paul
