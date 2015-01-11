Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbbAKJjH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 04:39:07 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42765 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbbAKJjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 04:39:00 -0500
Date: Sun, 11 Jan 2015 11:38:54 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/8] ARM: digicolor: add minimal device tree
 description
Message-ID: <20150111093853.GN2481@sapphire.tkos.co.il>
References: <cover.1420744368.git.baruch@tkos.co.il>
 <9d8d7aed6220e9e92ab70217a65d3291924cfa71.1420744369.git.baruch@tkos.co.il>
 <20150109114624.GB12942@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109114624.GB12942@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jan 09, 2015 at 11:46:24AM +0000, Mark Rutland wrote:
> On Thu, Jan 08, 2015 at 07:39:59PM +0000, Baruch Siach wrote:
> > cx92755.dtsi describes CX92755 on chip peripherals. conexant_equinox.dts
> > describes the Equinox evaluation board for the CX92755 SoC.
> 
> I didn't spot any cpu nodes below. While that might happen to work at
> the moment for UP, there really should be a node for the boot CPU.

OK. I'll add one in the next revision.

Thanks for reviewing.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
