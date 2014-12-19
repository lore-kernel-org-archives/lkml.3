Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaLSQtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 11:49:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaLSQtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 11:49:15 -0500
Date: Fri, 19 Dec 2014 08:49:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: atull <atull@opensource.altera.com>
Cc: Michal Simek <michal.simek@xilinx.com>, jgunthorpe@obsidianresearch.com,
        hpa@zytor.com, monstr@monstr.eu, rdunlap@infradead.org,
        mark.rutland@arm.com, linux-doc@vger.kernel.org, rubini@gnudd.com,
        pantelis.antoniou@konsulko.com, s.trumtrar@pengutronix.de,
        devel@driverdev.osuosl.org, sameo@linux.intel.com, nico@linaro.org,
        ijc+devicetree@hellion.org.uk, kyle.teske@ni.com,
        grant.likely@linaro.org, davidb@codeaurora.org,
        linus.walleij@linaro.org, cesarb@cesarb.net,
        devicetree@vger.kernel.org, jason@lakedaemon.net, pawel.moll@arm.com,
        iws@ovro.caltech.edu, broonie@kernel.org, philip@balister.org,
        dinguyen@opensource.altera.com, pavel@denx.de,
        yvanderv@opensource.altera.com, linux-kernel@vger.kernel.org,
        balbi@ti.com, delicious.quinoa@gmail.com, robh+dt@kernel.org,
        rob@landley.net, galak@codeaurora.org, akpm@linux-foundation.org,
        davem@davemloft.net, m.chehab@samsung.com
Subject: Re: [PATCH v6 0/4] FPGA Manager Framework
Message-ID: <20141219164913.GA20685@kroah.com>
References: <1418941748-16111-1-git-send-email-atull@opensource.altera.com>
 <5901b1791e1c4b09b72cb22c5eca68ca@BL2FFO11FD047.protection.gbl>
 <20141219153828.GA19077@kroah.com>
 <alpine.DEB.2.02.1412190945490.16892@linuxheads99>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1412190945490.16892@linuxheads99>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 09:47:26AM -0600, atull wrote:
> Thanks.  There is a one line change that the kbuild test robot has
> pointed out.  I can post v7 with just that change and let that be it.

Sure, or wait a week to see if anything else falls out and resend
then...

