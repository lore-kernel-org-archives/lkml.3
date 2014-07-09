Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaGIJ4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:56:03 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60175 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbaGIJ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:56:01 -0400
Date: Wed, 9 Jul 2014 11:55:52 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Re-send PATCH 1/1] arm: dra7xx: Add hwmod data for MDIO and CPSW
Message-ID: <20140709095552.GA25154@breakpoint.cc>
References: <1404825399-10330-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404825399-10330-1-git-send-email-mugunthanvnm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-08 18:46:39 [+0530], Mugunthan V N wrote:
> Adding hwmod data for CPSW and MDIO which is present in DRA7xx SoC

I reverted my patch, applied this one and after boot I got:

|platform 48485000.mdio: Cannot lookup hwmod 'davinci_mdio'
|cpsw 48484000.ethernet: _od_fail_runtime_resume: FIXME: missing hwmod/omap_dev info
|davinci_mdio 48485000.mdio: failed to get device clock
|davinci_mdio: probe of 48485000.mdio failed with error -2
|cpsw 48484000.ethernet: Random MACID = 46:c6:34:6f:8d:c6
| (null): fck is not found

with no eth0. Is there something with my setup? I still have the device
tree pieces I posted (in case there is something wrong with them).

Sebastian
