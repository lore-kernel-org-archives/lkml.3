Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbaGILvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:51:08 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22550 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754666AbaGILvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:51:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18FAgUvaVB34AxT66eX7VAy
Date: Wed, 9 Jul 2014 04:51:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Keerthy <a0393675@ti.com>
Cc: Keerthy <j-keerthy@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        mark.rutland@arm.com, galak@codeaurora.org, robh+dt@kernel.org,
        linux@arm.linux.org.uk, balbi@ti.com, kishon@ti.com,
        broonie@kernel.org
Subject: Re: [PATCH v3 0/7] ARM: dts: AM43x: Add devcice tree nodes
Message-ID: <20140709115106.GV28884@atomide.com>
References: <1404884193-20580-1-git-send-email-j-keerthy@ti.com>
 <20140709083114.GH28884@atomide.com>
 <53BD208E.6000507@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD208E.6000507@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Keerthy <a0393675@ti.com> [140709 04:03]:
> On Wednesday 09 July 2014 02:01 PM, Tony Lindgren wrote:
> >* Keerthy <j-keerthy@ti.com> [140708 22:40]:
> >>The patch series adds the device tree nodes and the corresponding
> >>documentation. The series also enabled tps65218 config options
> >>in the omap2plus_defconfig.
> >>
> >>The series is boot tested on both AM43x-epos-evm and AM437x-gp-evm.
> >Are the .dts changes safe to apply separately without breaking
> >anything?
> Tony,
> 
> Patch 1/7 had to be re-based on Mark's latest branch for tps65218.
> Other patches can be taken as is. These patches are boot tested on
> both am437x-gp-evm and am43x-epos-evm.

OK thanks applying patches 4 - 7 into omap-for-v3.17/dt.

Tony
